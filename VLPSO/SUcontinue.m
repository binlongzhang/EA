function [H] = SUcontinue(X,Y,divideNum)
%SUCONTINUE 此处显示有关此函数的摘要
%   此处显示详细说明
    Xmin = min(X);
    Xmax = max(X);
    Ymin = min(Y);
    Ymax = max(Y);
    pc = zeros(divideNum,divideNum);

    for i = 1:divideNum
        xDmin = Xmin + (Xmax-Xmin)*(i-1)/divideNum;
        xDmax = Xmin + (Xmax-Xmin)*(i)/divideNum;
        for j = 1: divideNum
            yDmin = Ymin + (Ymax-Ymin)*(j-1)/divideNum;
            yDmax = Ymin + (Ymax-Ymin)*(j)/divideNum;
            indexX = (X>=xDmin) & (X<=xDmax);
            indexY = (Y>=yDmin) & (Y<=yDmax);
            indexXY = indexX & indexY;
            pc(i,j)  = sum(indexXY);
        end
    end
    pc = pc/size(X,1);
    HyPc = sum(pc,1);
    HyPc(HyPc==0) = 1;
    HxPc = sum(pc,2);
    HxPc(HxPc==0) = 1;
    Hx = -sum(log2(HxPc).*HxPc);
    Hy = -sum(log2(HyPc).*HyPc);
    pc_Y_X = pc./HyPc;
    pc_Y_X(pc_Y_X==0) = 1;
    IG = Hx - sum(sum(-log2(pc_Y_X).* pc));
    H = IG/(Hx + Hy);
end

