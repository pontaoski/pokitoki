import Foundation

struct POEntry: Codable {
    var translatorComments: [String]
    var codeComments: [String]
    var references: [String]
    var flags: [String]
    var messageContext: String?
    var messageID: String
    var pluralMessageID: String?
    var translation: TranslationKind
}

struct POError: Error {
    let string: String
}

enum TranslationKind: Codable {
    case singular(String)
    case plural([Int: String])
}

struct POFile {
    var header: [String: String]
    var entries: [POEntry]

    func merged(with file: POFile) -> POFile {
        var newEntries: [POEntry] = []

        for entry in self.entries {
            let foundEntry = file.entries.first { item in
                item.messageID == entry.messageID &&
                item.pluralMessageID == entry.pluralMessageID
            }

            let defaultTranslation: TranslationKind
            if entry.pluralMessageID != nil {
                defaultTranslation = .plural([0: ""])
            } else {
                defaultTranslation = .singular("")
            }

            newEntries.append(POEntry.init(
                translatorComments: foundEntry?.translatorComments ?? [],
                codeComments: entry.codeComments,
                references: entry.references,
                flags: entry.flags,
                messageContext: entry.messageContext,
                messageID: entry.messageID,
                pluralMessageID: entry.pluralMessageID,
                translation: foundEntry?.translation ?? defaultTranslation
            ))
        }

        return POFile.init(header: self.header, entries: newEntries)
    }
}

extension String.SubSequence {
    func trimQuotes() -> String.SubSequence {
        self.dropFirst()
            .dropLast()
    }
}

extension String {
    func decodeFromPO() -> String {
        self.replacingOccurrences(of: "\\\\", with: "\\")
            .replacingOccurrences(of: "\\t", with: "\t")
            .replacingOccurrences(of: "\\n", with: "\n")
            .replacingOccurrences(of: "\\\"", with: "\"")
    }
    func encodeToPO() -> String {
        self.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\t", with: "\\t")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }
    func trimQuotes() -> String {
        String(self.dropFirst()
            .dropLast())
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

final class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}

func parsePOEntry(from paragraph: String) throws -> POEntry {
    enum BoxedTranslationKind {
        case singular(Box<String>)
        case plural(Box<[Int: Box<String>]>)
    }

    var entry = POEntry(
        translatorComments: [],
        codeComments: [],
        references: [],
        flags: [],
        messageContext: nil,
        messageID: "",
        pluralMessageID: nil,
        translation: .singular("")
    )
    let lines = paragraph.components(separatedBy: CharacterSet.newlines)
    var value = Box("")

    var messageID = Box("")
    var pluralMessageID = Box("")
    var messageContext = Box("")
    var translationKind = BoxedTranslationKind.singular(Box(""))

    for line in lines {
        if line.isEmpty {
            continue
        }

        let arr = line.split(separator: " ", maxSplits: 1)

        if line.first == "#" {
            if arr.count < 2 {
                continue
            }

            switch Array(line)[1] {
            case ":":
                entry.references.append(String(arr[1]))
            case ",":
                entry.flags.append(String(arr[1]))
            case " ":
                entry.translatorComments.append(String(arr[1]))
            case ".":
                entry.codeComments.append(String(arr[1]))
            case "|":
                continue
            default:
                continue
            }

            continue
        }

        if line.hasPrefix("msgid") {
            value = Box(String(arr[1].trimQuotes()).decodeFromPO())
            messageID = value
        } else if line.hasPrefix("msgid_plural") {
            value = Box(String(arr[1].trimQuotes()).decodeFromPO())
            pluralMessageID = value
        } else if line.hasPrefix("msgctxt") {
            value = Box(String(arr[1].trimQuotes()).decodeFromPO())
            messageContext = value
        } else if line.hasPrefix("msgstr") {
            let pfix = String(arr[0]).deletingPrefix("msgstr")
            value = Box(String(arr[1].trimQuotes()).decodeFromPO())

            if pfix.length == 0 {
                translationKind = .singular(value)
            } else {
                guard let num = Int(pfix.trimQuotes()) else {
                    throw POError(string: "malformed number for plural msgstr: " + pfix.trimQuotes())
                }

                if case .plural(let trans) = translationKind {
                    trans.value[num] = value
                } else {
                    translationKind = .plural(Box([num: value]))
                }
            }
        } else {
            value.value += line.decodeFromPO().trimQuotes()
        }
    }

    entry.messageID = messageID.value
    entry.pluralMessageID = pluralMessageID.value
    entry.messageContext = messageContext.value
    switch translationKind {
    case .singular(let box):
        entry.translation = .singular(box.value)
    case .plural(let box):
        var trans: [Int : String] = [:]
        for (key, value) in box.value {
            trans[key] = value.value
        }
        entry.translation = .plural(trans)
    }

    return entry
}

func parsePoHeader(from string: String) throws -> [String: String] {
    var ret: [String: String] = [:]
    let lines = string.components(separatedBy: CharacterSet.newlines)
    var value = ""
    var key: String? = nil

    for line in lines {
        if line.isEmpty {
            continue
        }

        if line.first != "\"" || line.last != "\"" {
            continue
        }

        let stripped = line.trimQuotes()
        let array = stripped.components(separatedBy: ":")

        if array.count == 0 {
            continue
        }

        let str = array.first?.decodeFromPO().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if array.count < 2 {
            value += str ?? ""
            continue
        }

        if let key = key {
            ret[key] = value
        }

        key = str
        value = array[1].decodeFromPO().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    return ret
}

func parseFile(from: String) throws -> POFile {
    let paragraphs = from.components(separatedBy: "\n\n")
    guard let header = paragraphs.first else {
        throw POError.init(string: "header was nil")
    }

    return POFile.init(header: try parsePoHeader(from: header), entries: try paragraphs.dropFirst().map(parsePOEntry))
}
