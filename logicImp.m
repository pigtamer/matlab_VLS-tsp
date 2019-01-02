function logicImp(city, NUM_TYPES,MaxCityNum)
    global cityCell;
    global topFlag
    %��ʼ
    cityCell{1} = city;
    
    %�������
    while(1)
        %���ȫ������ײ��������˳���ѭ��
        if allCityGroupMinEnough(cityCell,MaxCityNum)
            break;
        end
        
        %������������
        cityCellLength = length(cityCell);
        cityCellNew={};
        for i=1:cityCellLength
        %����ȺԤ����
            cur_city_group = cityCell{i};
            [cur_city_group_x,cur_city_group_y]=size(cur_city_group);
            if cur_city_group_x < MaxCityNum
                cityCellNew=[cityCellNew;cur_city_group];
                continue;
            end
            
            if i==1
                pre_city_group = cityCell{cityCellLength};
            else
                pre_city_group = cityCell{i-1};
            end
            if i==cityCellLength
                nxt_city_group = cityCell{1};
            else
                nxt_city_group = cityCell{i+1};
            end
            
            %����õ��������������������cur_city_group_cluster
            [pre_city_group_size_x,pre_city_group_size_y]=size(pre_city_group);
            [nxt_city_group_size_x,nxt_city_group_size_y]=size(nxt_city_group);
            PRE_NUM_TYPES = NUM_TYPES;
            NXT_NUM_TYPES = NUM_TYPES;
            if pre_city_group_size_x<PRE_NUM_TYPES
                PRE_NUM_TYPES = pre_city_group_size_x;
            end
            if nxt_city_group_size_x<NXT_NUM_TYPES
                NXT_NUM_TYPES = nxt_city_group_size_x;
            end
            
            [Idx, Centers] = kmeans(cur_city_group(:, 1:2), NUM_TYPES, 'Distance','sqeuclidean',...
                    'Replicates',10,'Options',statset('Display','final'));
            [Idx_pre, Centers_pre] = kmeans(pre_city_group(:, 1:2), PRE_NUM_TYPES, 'Distance','sqeuclidean',...
                    'Replicates',10,'Options',statset('Display','final'));    
            [Idx_nxt, Centers_nxt] = kmeans(nxt_city_group(:, 1:2), NXT_NUM_TYPES, 'Distance','sqeuclidean',...
                    'Replicates',10,'Options',statset('Display','final'));
                
            cur_city_group_cluster=cell(length(Centers),1);
            for k = 1:length(Centers)
                cur_city_group_cluster{k} = cur_city_group(Idx == k, :); % create subsets of this swarm
            end
            
            %�õ���ʼ������ֹ��
            group_npoint_s=nearestPoint(Centers, Centers_pre);group_npoint_s=group_npoint_s(1);
            group_npoint_e=nearestPoint(Centers, Centers_nxt);group_npoint_e=group_npoint_e(1);
            
            %�������յ�һ������������ͻ���ı�һ��
            if group_npoint_s==group_npoint_e
                group_npoint_e=secNearPt(group_npoint_e,Centers, Centers_nxt);group_npoint_e=group_npoint_e(1);
            end
            if group_npoint_s==group_npoint_e
                group_npoint_s=secNearPt(group_npoint_s,Centers, Centers_pre);group_npoint_s=group_npoint_s(1);
            end
            
            %�滮·��
            if topFlag == 1
                [group_Road,group_Cost]=circleTspSolver(length(Centers),1,Centers(:, 1),Centers(:, 2));
                topFlag = 0;
            else
                [group_Road,group_Cost]=tspSolver(length(Centers),group_npoint_s,group_npoint_e,...
                                Centers(:, 1),Centers(:, 2));
            end
            
            %��������
            cur_city_group_cluster = cur_city_group_cluster(group_Road); 
            cityCellNew=[cityCellNew;cur_city_group_cluster];
             
        end
        cityCell = cityCellNew;
    end
    
    %������ײ�
    cityCellLength = length(cityCell);
    for i =1:cityCellLength
        %����ȺԤ����
        cur_citygroup = cityCell{i};
        if i==1
            pre_citygroup = cityCell{cityCellLength};
        else
            pre_citygroup = cityCell{i-1};
        end
        if i==cityCellLength
            nxt_citygroup = cityCell{1};
        else
            nxt_citygroup = cityCell{i+1};
        end
        
        %�ײ������
        npoint_s=nearestPoint(cur_citygroup, pre_citygroup);npoint_s=npoint_s(1);
        npoint_e=nearestPoint(cur_citygroup, nxt_citygroup);npoint_e=npoint_e(1);
         %�������յ�һ������������ͻ���ı�һ��
        if npoint_s==npoint_e
            npoint_e=secNearPt(npoint_e,cur_citygroup, nxt_citygroup);npoint_e=npoint_e(1);
        end
        if npoint_s==npoint_e
             npoint_s=secNearPt(npoint_s,cur_citygroup, pre_citygroup);npoint_s=npoint_s(1);
        end
        
        % ���������滮
        [ncity_x,ncity_y]=size(cur_citygroup);
        [Road,Cost]=tspSolver(ncity_x,npoint_s,npoint_e,cur_citygroup(:, 1),cur_citygroup(:, 2));
        
        %������
        cur_citygroup = cur_citygroup(Road,:);
        cityCell{i} = cur_citygroup;
    end
end

function label = allCityGroupMinEnough(cityCell,MaxCityNum)
    cityCellLen=length(cityCell);
    label=1;
    for i=1:cityCellLen
        [cityGroup_x,cityGroup_y] = size(cityCell{i});
        if cityGroup_x>MaxCityNum
            label = 0;
            break;
        end
    end
end