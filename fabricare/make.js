// Created by Grigore Stefan <g_stefan@yahoo.com>
// Public domain (Unlicense) <http://unlicense.org>
// SPDX-FileCopyrightText: 2022-2023 Grigore Stefan <g_stefan@yahoo.com>
// SPDX-License-Identifier: Unlicense

Fabricare.include("vendor");

messageAction("make");

if (Shell.fileExists("temp/build.done.flag")) {
	return;
};

if (!Shell.directoryExists("source")) {
	exitIf(Shell.system("7z x -aoa archive/" + Project.vendor + ".7z"));
	Shell.rename(Project.vendor, "source");
};

Shell.mkdirRecursivelyIfNotExists("output");
Shell.mkdirRecursivelyIfNotExists("output/bin");
Shell.mkdirRecursivelyIfNotExists("output/include");
Shell.mkdirRecursivelyIfNotExists("output/lib");
Shell.mkdirRecursivelyIfNotExists("temp");

Shell.copyFile("fabricare/source/src.osdep.nt.env_nt.c","source/src/osdep/nt/env_nt.c");
Shell.copyFile("fabricare/source/src.osdep.nt.yunchan.c","source/src/osdep/nt/yunchan.c");

runInPath("source",function(){
	exitIf(Shell.system("nmake /f makefile.w2k"));
});

Shell.copyFile("source/c-client/cclient.lib","output/lib/cclient.lib");
Shell.copyFile("source/c-client/cclient.lib","output/lib/cclient.static.lib");
Shell.copyFile("source/imapd/imapd.exe","output/bin/imapd.exe");
Shell.copyFile("source/ipopd/ipop2d.exe","output/bin/ipop2d.exe");
Shell.copyFile("source/ipopd/ipop3d.exe","output/bin/ipop3d.exe");
Shell.copyFile("source/mailutil/mailutil.exe","output/bin/mailutil.exe");
Shell.mkdirRecursivelyIfNotExists("output/include/c-client");
Shell.copyFilesToDirectory("source/c-client/*.h","output/include/c-client");

runInPath("source",function(){
	exitIf(Shell.system("nmake /f makefile.w2k clean"));
});

Shell.filePutContents("temp/build.done.flag", "done");

