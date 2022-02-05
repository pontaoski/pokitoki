@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    // func testHelloWorld() throws {
    //     let app = Application(.testing)
    //     defer { app.shutdown() }
    //     try configure(app)

    //     try app.test(.GET, "hello", afterResponse: { res in
    //         XCTAssertEqual(res.status, .ok)
    //         XCTAssertEqual(res.body.string, "Hello, world!")
    //     })
    // }
    func testPoParser() throws {
        let pofile = ##"""
msgid ""
msgstr ""
"MIME-Version: 1.0\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Qt-Contexts: true\n"

#: lib/io/kfilesystemtype.cpp:186
msgctxt "KFileSystemType|"
msgid "NFS"
msgstr ""

#: lib/io/kfilesystemtype.cpp:188
msgctxt "KFileSystemType|"
msgid "SMB"
msgstr ""

#: lib/io/kfilesystemtype.cpp:190
msgctxt "KFileSystemType|"
msgid "FAT"
msgstr ""

#: lib/io/kfilesystemtype.cpp:192
msgctxt "KFileSystemType|"
msgid "RAMFS"
msgstr ""

#: lib/io/kfilesystemtype.cpp:194
msgctxt "KFileSystemType|"
msgid "Other"
msgstr ""

#: lib/io/kfilesystemtype.cpp:196
msgctxt "KFileSystemType|"
msgid "NTFS"
msgstr ""

#: lib/io/kfilesystemtype.cpp:198
msgctxt "KFileSystemType|"
msgid "ExFAT"
msgstr ""

#: lib/io/kfilesystemtype.cpp:200
msgctxt "KFileSystemType|"
msgid "Unknown"
msgstr ""

#: lib/kaboutdata.cpp:265
msgctxt "KAboutLicense|"
msgid ""
"No licensing terms for this program have been specified.\n"
"Please check the documentation or the source for any\n"
"licensing terms.\n"
msgstr ""

#: lib/kaboutdata.cpp:273
#, qt-format
msgctxt "KAboutLicense|"
msgid "This program is distributed under the terms of the %1."
msgstr ""

#: lib/kaboutdata.cpp:317
msgctxt "KAboutLicense|@item license (short name)"
msgid "GPL v2"
msgstr ""

#: lib/kaboutdata.cpp:318
msgctxt "KAboutLicense|@item license"
msgid "GNU General Public License Version 2"
msgstr ""

#: lib/kaboutdata.cpp:321
msgctxt "KAboutLicense|@item license (short name)"
msgid "LGPL v2"
msgstr ""

#: lib/kaboutdata.cpp:322
msgctxt "KAboutLicense|@item license"
msgid "GNU Lesser General Public License Version 2"
msgstr ""

#: lib/kaboutdata.cpp:325
msgctxt "KAboutLicense|@item license (short name)"
msgid "BSD License"
msgstr ""

#: lib/kaboutdata.cpp:326
msgctxt "KAboutLicense|@item license"
msgid "BSD License"
msgstr ""

#: lib/kaboutdata.cpp:329
msgctxt "KAboutLicense|@item license (short name)"
msgid "Artistic License"
msgstr ""

#: lib/kaboutdata.cpp:330
msgctxt "KAboutLicense|@item license"
msgid "Artistic License"
msgstr ""

#: lib/kaboutdata.cpp:333
msgctxt "KAboutLicense|@item license (short name)"
msgid "QPL v1.0"
msgstr ""

#: lib/kaboutdata.cpp:334
msgctxt "KAboutLicense|@item license"
msgid "Q Public License"
msgstr ""

#: lib/kaboutdata.cpp:337
msgctxt "KAboutLicense|@item license (short name)"
msgid "GPL v3"
msgstr ""

#: lib/kaboutdata.cpp:338
msgctxt "KAboutLicense|@item license"
msgid "GNU General Public License Version 3"
msgstr ""

#: lib/kaboutdata.cpp:341
msgctxt "KAboutLicense|@item license (short name)"
msgid "LGPL v3"
msgstr ""

#: lib/kaboutdata.cpp:342
msgctxt "KAboutLicense|@item license"
msgid "GNU Lesser General Public License Version 3"
msgstr ""

#: lib/kaboutdata.cpp:345
msgctxt "KAboutLicense|@item license (short name)"
msgid "LGPL v2.1"
msgstr ""

#: lib/kaboutdata.cpp:346
msgctxt "KAboutLicense|@item license"
msgid "GNU Lesser General Public License Version 2.1"
msgstr ""

#: lib/kaboutdata.cpp:350
msgctxt "KAboutLicense|@item license"
msgid "Custom"
msgstr ""

#: lib/kaboutdata.cpp:353
msgctxt "KAboutLicense|@item license"
msgid "Not specified"
msgstr ""

#: lib/kaboutdata.cpp:954
msgctxt "KAboutData|replace this with information about your translation team"
msgid ""
"<p>KDE is translated into many languages thanks to the work of the "
"translation teams all over the world.</p><p>For more information on KDE "
"internationalization visit <a "
"href=\"https://l10n.kde.org\">https://l10n.kde.org</a></p>"
msgstr ""

#: lib/kaboutdata.cpp:1212
msgctxt "KAboutData CLI|"
msgid "Show author information."
msgstr ""

#: lib/kaboutdata.cpp:1213
msgctxt "KAboutData CLI|"
msgid "Show license information."
msgstr ""

#: lib/kaboutdata.cpp:1215
msgctxt "KAboutData CLI|"
msgid "The base file name of the desktop entry for this application."
msgstr ""

#: lib/kaboutdata.cpp:1216
msgctxt "KAboutData CLI|"
msgid "file name"
msgstr ""

#: lib/kaboutdata.cpp:1226
msgctxt "KAboutData CLI|"
msgid "This application was written by somebody who wants to remain anonymous."
msgstr ""

#: lib/kaboutdata.cpp:1228
#, qt-format
msgctxt "KAboutData CLI|"
msgid "%1 was written by:"
msgstr ""

#: lib/kaboutdata.cpp:1239
msgctxt "KAboutData CLI|"
msgid "Please use https://bugs.kde.org to report bugs."
msgstr ""

#: lib/kaboutdata.cpp:1241
#, qt-format
msgctxt "KAboutData CLI|"
msgid "Please report bugs to %1."
msgstr ""

#: lib/plugin/kpluginfactory.cpp:41
#, qt-format
msgctxt "KPluginFactory|"
msgid "Could not find plugin %1"
msgstr ""

#: lib/plugin/kpluginfactory.cpp:50
#, qt-format
msgctxt "KPluginFactory|"
msgid "Could not load plugin from %1: %2"
msgstr ""

#: lib/plugin/kpluginfactory.cpp:61
#, qt-format
msgctxt "KPluginFactory|"
msgid "The library %1 does not offer a KPluginFactory."
msgstr ""

#: lib/plugin/kpluginfactory.h:511
#, qt-format
msgctxt "KPluginFactory|"
msgid "KPluginFactory could not load the plugin: %1"
msgstr ""

#: lib/plugin/kpluginloader.cpp:109
#, qt-format
msgctxt "KPluginLoader|"
msgid "The library %1 does not offer a KPluginFactory."
msgstr ""

#: lib/util/kformatprivate.cpp:100
msgctxt "KFormat|SI prefix for 10^⁻24"
msgid "y"
msgstr ""

#: lib/util/kformatprivate.cpp:101
msgctxt "KFormat|SI prefix for 10^⁻21"
msgid "z"
msgstr ""

#: lib/util/kformatprivate.cpp:102
msgctxt "KFormat|SI prefix for 10^⁻18"
msgid "a"
msgstr ""

#: lib/util/kformatprivate.cpp:103
msgctxt "KFormat|SI prefix for 10^⁻15"
msgid "f"
msgstr ""

#: lib/util/kformatprivate.cpp:104
msgctxt "KFormat|SI prefix for 10^⁻12"
msgid "p"
msgstr ""

#: lib/util/kformatprivate.cpp:105
msgctxt "KFormat|SI prefix for 10^⁻9"
msgid "n"
msgstr ""

#: lib/util/kformatprivate.cpp:106
msgctxt "KFormat|SI prefix for 10^⁻6"
msgid "µ"
msgstr ""

#: lib/util/kformatprivate.cpp:107
msgctxt "KFormat|SI prefix for 10^⁻3"
msgid "m"
msgstr ""

#: lib/util/kformatprivate.cpp:109
msgctxt "KFormat|SI prefix for 10^3"
msgid "k"
msgstr ""

#: lib/util/kformatprivate.cpp:109
msgctxt "KFormat|IEC binary prefix for 2^10"
msgid "Ki"
msgstr ""

#: lib/util/kformatprivate.cpp:110
msgctxt "KFormat|SI prefix for 10^6"
msgid "M"
msgstr ""

#: lib/util/kformatprivate.cpp:110
msgctxt "KFormat|IEC binary prefix for 2^20"
msgid "Mi"
msgstr ""

#: lib/util/kformatprivate.cpp:111
msgctxt "KFormat|SI prefix for 10^9"
msgid "G"
msgstr ""

#: lib/util/kformatprivate.cpp:111
msgctxt "KFormat|IEC binary prefix for 2^30"
msgid "Gi"
msgstr ""

#: lib/util/kformatprivate.cpp:112
msgctxt "KFormat|SI prefix for 10^12"
msgid "T"
msgstr ""

#: lib/util/kformatprivate.cpp:112
msgctxt "KFormat|IEC binary prefix for 2^40"
msgid "Ti"
msgstr ""

#: lib/util/kformatprivate.cpp:113
msgctxt "KFormat|SI prefix for 10^15"
msgid "P"
msgstr ""

#: lib/util/kformatprivate.cpp:113
msgctxt "KFormat|IEC binary prefix for 2^50"
msgid "Pi"
msgstr ""

#: lib/util/kformatprivate.cpp:114
msgctxt "KFormat|SI prefix for 10^18"
msgid "E"
msgstr ""

#: lib/util/kformatprivate.cpp:114
msgctxt "KFormat|IEC binary prefix for 2^60"
msgid "Ei"
msgstr ""

#: lib/util/kformatprivate.cpp:115
msgctxt "KFormat|SI prefix for 10^21"
msgid "Z"
msgstr ""

#: lib/util/kformatprivate.cpp:115
msgctxt "KFormat|IEC binary prefix for 2^70"
msgid "Zi"
msgstr ""

#: lib/util/kformatprivate.cpp:116
msgctxt "KFormat|SI prefix for 10^24"
msgid "Y"
msgstr ""

#: lib/util/kformatprivate.cpp:116
msgctxt "KFormat|IEC binary prefix for 2^80"
msgid "Yi"
msgstr ""

#: lib/util/kformatprivate.cpp:125
msgctxt "KFormat|Symbol of binary digit"
msgid "bit"
msgstr ""

#: lib/util/kformatprivate.cpp:128
msgctxt "KFormat|Symbol of byte"
msgid "B"
msgstr ""

#: lib/util/kformatprivate.cpp:131
msgctxt "KFormat|Symbol of meter"
msgid "m"
msgstr ""

#: lib/util/kformatprivate.cpp:134
msgctxt "KFormat|Symbol of hertz"
msgid "Hz"
msgstr ""

#. value without prefix, format "<val> <unit>"
#: lib/util/kformatprivate.cpp:143
#, qt-format
msgctxt "KFormat|no Prefix"
msgid "%1 %2"
msgstr ""

#. value with prefix, format "<val> <prefix><unit>"
#: lib/util/kformatprivate.cpp:162
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 %2%3"
msgstr ""

#. MetricBinaryDialect size in bytes
#: lib/util/kformatprivate.cpp:212
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 B"
msgstr ""

#. MetricBinaryDialect size in 1000 bytes
#: lib/util/kformatprivate.cpp:215
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 kB"
msgstr ""

#. MetricBinaryDialect size in 10^6 bytes
#: lib/util/kformatprivate.cpp:218
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 MB"
msgstr ""

#. MetricBinaryDialect size in 10^9 bytes
#: lib/util/kformatprivate.cpp:221
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 GB"
msgstr ""

#. MetricBinaryDialect size in 10^12 bytes
#: lib/util/kformatprivate.cpp:224
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 TB"
msgstr ""

#. MetricBinaryDialect size in 10^15 bytes
#: lib/util/kformatprivate.cpp:227
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 PB"
msgstr ""

#. MetricBinaryDialect size in 10^18 byte
#: lib/util/kformatprivate.cpp:230
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 EB"
msgstr ""

#. MetricBinaryDialect size in 10^21 bytes
#: lib/util/kformatprivate.cpp:233
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 ZB"
msgstr ""

#. MetricBinaryDialect size in 10^24 bytes
#: lib/util/kformatprivate.cpp:236
#, qt-format
msgctxt "KFormat|MetricBinaryDialect"
msgid "%1 YB"
msgstr ""

#. JEDECBinaryDialect memory size in bytes
#: lib/util/kformatprivate.cpp:242
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 B"
msgstr ""

#. JEDECBinaryDialect memory size in 1024 bytes
#: lib/util/kformatprivate.cpp:245
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 KB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^20 bytes
#: lib/util/kformatprivate.cpp:248
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 MB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^30 bytes
#: lib/util/kformatprivate.cpp:251
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 GB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^40 bytes
#: lib/util/kformatprivate.cpp:254
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 TB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^50 bytes
#: lib/util/kformatprivate.cpp:257
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 PB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^60 bytes
#: lib/util/kformatprivate.cpp:260
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 EB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^70 bytes
#: lib/util/kformatprivate.cpp:263
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 ZB"
msgstr ""

#. JEDECBinaryDialect memory size in 10^80 bytes
#: lib/util/kformatprivate.cpp:266
#, qt-format
msgctxt "KFormat|JEDECBinaryDialect"
msgid "%1 YB"
msgstr ""

#. IECBinaryDialect size in bytes
#: lib/util/kformatprivate.cpp:272
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 B"
msgstr ""

#. IECBinaryDialect size in 1024 bytes
#: lib/util/kformatprivate.cpp:275
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 KiB"
msgstr ""

#. IECBinaryDialect size in 10^20 bytes
#: lib/util/kformatprivate.cpp:278
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 MiB"
msgstr ""

#. IECBinaryDialect size in 10^30 bytes
#: lib/util/kformatprivate.cpp:281
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 GiB"
msgstr ""

#. IECBinaryDialect size in 10^40 bytes
#: lib/util/kformatprivate.cpp:284
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 TiB"
msgstr ""

#. IECBinaryDialect size in 10^50 bytes
#: lib/util/kformatprivate.cpp:287
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 PiB"
msgstr ""

#. IECBinaryDialect size in 10^60 bytes
#: lib/util/kformatprivate.cpp:290
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 EiB"
msgstr ""

#. IECBinaryDialect size in 10^70 bytes
#: lib/util/kformatprivate.cpp:293
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 ZiB"
msgstr ""

#. IECBinaryDialect size in 10^80 bytes
#: lib/util/kformatprivate.cpp:296
#, qt-format
msgctxt "KFormat|IECBinaryDialect"
msgid "%1 YiB"
msgstr ""

#. @item:intext Duration format minutes, seconds and milliseconds
#: lib/util/kformatprivate.cpp:333
#, qt-format
msgctxt "KFormat|"
msgid "%1m%2.%3s"
msgstr ""

#. @item:intext Duration format minutes and seconds
#: lib/util/kformatprivate.cpp:336
#, qt-format
msgctxt "KFormat|"
msgid "%1m%2s"
msgstr ""

#. @item:intext Duration format hours and minutes
#: lib/util/kformatprivate.cpp:339
#, qt-format
msgctxt "KFormat|"
msgid "%1h%2m"
msgstr ""

#. @item:intext Duration format hours, minutes, seconds, milliseconds
#: lib/util/kformatprivate.cpp:342
#, qt-format
msgctxt "KFormat|"
msgid "%1h%2m%3.%4s"
msgstr ""

#. @item:intext Duration format hours, minutes, seconds
#: lib/util/kformatprivate.cpp:349
#, qt-format
msgctxt "KFormat|"
msgid "%1h%2m%3s"
msgstr ""

#. @item:intext Duration format minutes, seconds and milliseconds
#: lib/util/kformatprivate.cpp:355
#, qt-format
msgctxt "KFormat|"
msgid "%1:%2.%3"
msgstr ""

#. @item:intext Duration format minutes and seconds
#. ----------
#. @item:intext Duration format hours and minutes
#: lib/util/kformatprivate.cpp:358 lib/util/kformatprivate.cpp:361
#, qt-format
msgctxt "KFormat|"
msgid "%1:%2"
msgstr ""

#. @item:intext Duration format hours, minutes, seconds, milliseconds
#: lib/util/kformatprivate.cpp:364
#, qt-format
msgctxt "KFormat|"
msgid "%1:%2:%3.%4"
msgstr ""

#. @item:intext Duration format hours, minutes, seconds
#: lib/util/kformatprivate.cpp:371
#, qt-format
msgctxt "KFormat|"
msgid "%1:%2:%3"
msgstr ""

#. @item:intext %1 is a real number, e.g. 1.23 days
#: lib/util/kformatprivate.cpp:383
#, qt-format
msgctxt "KFormat|"
msgid "%1 days"
msgstr ""

#. @item:intext %1 is a real number, e.g. 1.23 hours
#: lib/util/kformatprivate.cpp:386
#, qt-format
msgctxt "KFormat|"
msgid "%1 hours"
msgstr ""

#. @item:intext %1 is a real number, e.g. 1.23 minutes
#: lib/util/kformatprivate.cpp:389
#, qt-format
msgctxt "KFormat|"
msgid "%1 minutes"
msgstr ""

#. @item:intext %1 is a real number, e.g. 1.23 seconds
#: lib/util/kformatprivate.cpp:392
#, qt-format
msgctxt "KFormat|"
msgid "%1 seconds"
msgstr ""

#. @item:intext %1 is a whole number
#: lib/util/kformatprivate.cpp:397
#, qt-format
msgctxt "KFormat|"
msgid "%n millisecond(s)"
msgid_plural "%n millisecond(s)"
msgstr[0] ""

#. @item:intext %n is a whole number
#: lib/util/kformatprivate.cpp:415
#, qt-format
msgctxt "KFormat|"
msgid "%n day(s)"
msgid_plural "%n day(s)"
msgstr[0] ""

#. @item:intext %n is a whole number
#: lib/util/kformatprivate.cpp:420
#, qt-format
msgctxt "KFormat|"
msgid "%n hour(s)"
msgid_plural "%n hour(s)"
msgstr[0] ""

#. @item:intext %n is a whole number
#: lib/util/kformatprivate.cpp:425
#, qt-format
msgctxt "KFormat|"
msgid "%n minute(s)"
msgid_plural "%n minute(s)"
msgstr[0] ""

#. @item:intext %n is a whole number
#: lib/util/kformatprivate.cpp:430
#, qt-format
msgctxt "KFormat|"
msgid "%n second(s)"
msgid_plural "%n second(s)"
msgstr[0] ""

#. @item:intext days and hours. This uses the previous item:intext messages. If this does not fit the grammar of your language please contact the i18n team to solve the problem
#. ----------
#. @item:intext hours and minutes. This uses the previous item:intext messages. If this does not fit the grammar of your language please contact the i18n team to solve the problem
#. ----------
#. @item:intext minutes and seconds. This uses the previous item:intext messages. If this does not fit the grammar of your language please contact the i18n team to solve the problem
#: lib/util/kformatprivate.cpp:455 lib/util/kformatprivate.cpp:461
#: lib/util/kformatprivate.cpp:467
#, qt-format
msgctxt "KFormat|"
msgid "%1 and %2"
msgstr ""

#: lib/util/kformatprivate.cpp:478
msgctxt ""
"KFormat|used when a relative date string can't be generated because the date "
"is invalid"
msgid "Invalid date"
msgstr ""

#: lib/util/kformatprivate.cpp:488
msgctxt "KFormat|"
msgid "In two days"
msgstr ""

#: lib/util/kformatprivate.cpp:490
msgctxt "KFormat|"
msgid "Tomorrow"
msgstr ""

#: lib/util/kformatprivate.cpp:492
msgctxt "KFormat|"
msgid "Today"
msgstr ""

#: lib/util/kformatprivate.cpp:494
msgctxt "KFormat|"
msgid "Yesterday"
msgstr ""

#: lib/util/kformatprivate.cpp:496
msgctxt "KFormat|"
msgid "Two days ago"
msgstr ""

#: lib/util/kformatprivate.cpp:510
msgctxt "KFormat|"
msgid "Just now"
msgstr ""

#: lib/util/kformatprivate.cpp:512
#, qt-format
msgctxt "KFormat|"
msgid "%1 minutes ago"
msgstr ""

#. relative datetime with %1 result of QLocale.toString(date, format) or formatRelativeDate and %2 result of QLocale.toString(time, timeformatType) If this does not fit the grammar of your language please contact the i18n team to solve the problem
#: lib/util/kformatprivate.cpp:528
#, qt-format
msgctxt "KFormat|"
msgid "%1 at %2"
msgstr ""

#: lib/util/klistopenfilesjob_unix.cpp:36
#, qt-format
msgctxt "QObject|"
msgid "Path %1 doesn't exist"
msgstr ""

#: lib/util/klistopenfilesjob_unix.cpp:49
#, qt-format
msgctxt "QObject|"
msgid "Failed to execute `lsof' error code %1"
msgstr ""

#: lib/util/klistopenfilesjob_win.cpp:27
msgctxt "QObject|"
msgid "KListOpenFilesJob is not supported on Windows"
msgstr ""
"""##


        let val = try parseFile(from: pofile)
        print(val)
    }
}
