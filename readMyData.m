
function data=readMyData(fileName)
% Author: Siamak Ghorbani Faal
% Date: 09/21/2014
% Copyright @ Siamak Ghorbani Faal. All rights reserved


fileID = fopen(fileName);
formatData = '"%f""%f""%f""%f""%f"';

n = 1;

while(1)
    string = fscanf(fileID,'%s%[^\r]%');
    string = strrep(string,',','');
    
    if(isempty(string))
        break
    end
    
    vector = sscanf(string,formatData)';
    
    if(~isempty(vector))
        data(n,:) = vector;
        n = n + 1;
    end
    
end

fclose(fileID);