clc
clear
dataOrigin = importdata('DLBCL.xlsx');
dataX = dataOrigin.data;
label = dataOrigin.textdata;

className = tabulate(label);
className = className(:,1);
dataY = zeros(size(label));
for i = 1:size(label,1)
    for j = 1:size(className,1)
        if isequal(className{j},label{i})
            dataY(i) = j;
            break;
        end
    end
end
