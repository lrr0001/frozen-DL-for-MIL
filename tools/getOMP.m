function ompPath = getOMP()
fid = fopen('r-eStatesAndPaths/OMPPath.txt');
ompPath = fgetl(fid);
fclose(fid);
if ompPath(end) ~= '/'
    ompPath = [ompPath,'/'];
end
end