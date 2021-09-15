function header = readHeader(fileName)
fileID = fopen(fileName);


format = {'%s%s%s','%s%f%s','%s%f%s','%s%f%s','%s%f%s'};
header.values = [];
header.properties = [];

for n=1:5
    string = fscanf(fileID,'%s%[^\r]%');
    string = strrep(string,'Specimen properties : ','');
    string = strrep(string,'"','');
    string = strrep(string,' ','');
    [s1,s2,~] = strread(string,format{n},'delimiter', ',');
    if(n==1)
        header.properties {1} = s1;
        header.specimenLabel = s2;
    else
        header.properties {n} = s1;
        header.values(n) = s2;
    end
end