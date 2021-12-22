function plot_route( pos,R )
%PLOT_ROUTE 根据物种个体的染色题和城市坐标来绘制行走路径
%   此处显示详细说明
    scatter(pos(:, 1), pos(:, 2), 'rx')
    hold on;
    plot([pos(R(1), 1), pos(R(length(R)), 1)], [pos(R(1), 2), pos(R(length(R)), 2)]) % 绘制起始点和终止点连线
    hold on;
    for i = 2:length(R)
        x0 = pos(R(i - 1), 1);
        y0 = pos(R(i - 1), 2);
        x1 = pos(R(i), 1);
        y1 = pos(R(i), 2);
        plot([x0, x1], [y0, y1]);
        hold on;
    end
end

