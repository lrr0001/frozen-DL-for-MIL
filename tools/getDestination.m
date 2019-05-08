function destination = getDestination()
fid = fopen('r-eStatesAndPaths/DESTINATION.txt');
destination = fgetl(fid);
fclose(fid);
if destination(end) ~= '/'
    destination = [destination,'/'];
end
end