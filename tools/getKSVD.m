function ksvdPath = getKSVD()
fid = fopen('r-eStatesAndPaths/KSVDPath.txt');
ksvdPath = fgetl(fid);
fclose(fid);
if ksvdPath(end) ~= '/'
    ksvdPath = [ksvdPath,'/'];
end
end