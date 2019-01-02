function Idx = secNearPt(IdxToDeleteFrom1, data1, data2)
    [data1_x,data1_y]=size(data1);
    [data2_x,data2_y]=size(data2);
    mindis = inf;
    Idx = [1 1];
    for k1 = 1 : data1_x
        pt1 = data1(k1, 1:2);
        for k2 = 1:data2_x
            pt2 = data2(k2, 1:2);
            disthis = sum((pt1 - pt2).^2);
            if disthis < mindis && Idx(1) ~= IdxToDeleteFrom1 
                mindis = disthis;
                Idx(2) = k2;
                Idx(1) = k1;
            end
        end
    end
    if rows(data1) == 1
       Idx(1) = 1; 
    end
    if rows(data2) == 1
       Idx(2) = 1; 
    end
    
%     pts(1, :) = data1(Idx(1), :);
%     pts(2, :) = data2(Idx(2), :);
    
%     figure(332)
%     plot(pts( :,1), pts( :, 2), 'k', 'linewidth', 1.5)
%     hold on
%     scatter(data1(:, 1), data1(:, 2), 'v', 'filled')
%     
%     scatter(data2(:, 1), data2(:, 2), 'o', 'filled')
%     scatter(data1(Idx(1), 1), data1(Idx(1), 2), 25, 'kv','filled')
%     scatter(data2(Idx(2), 1), data2(Idx(2), 2), 25, 'ro', 'filled')
%     hold off
%     grid minor
%     title("Second neighbor")
end