clear;clc;close all
% Initiate comsol
import com.comsol.model.*
import com.comsol.model.util.*


%% Inputs

model = mphopen('LJH_Fast_Charging_Tubular_Cell_230426'); 

data_accum = table();

for C_1D = 0.1:0.5:12.1

    for D_in = 0:0.25:4
    
    try
    
    model.param.set('C_1D',C_1D);
    model.param.set('D_in',D_in);

    model.study('std2').run

    catch 
       

        continue;
        
    end


    [area] = mphglobal(model, {'A_jrtotal'});
    [SOC_Cylinder] = mphglobal(model,'comp1.SOC');
    [SOC_Tubular] = mphglobal(model,'comp3.SOC');
    [phia] = mphglobal(model,{'phil_max'});
    [phis] = mphglobal(model,{'phis_max'});
    [T_ref] = mphglobal(model,{'T0'});
    [C_rate] = mphglobal(model,{'C_1D'});
    [I_current] = mphglobal(model,{'I_1C_2D'});
    [OCP] = mphglobal(model,{'E_cell'});
    [Cathode_Potential] = mphglobal(model,{'E_cathode'});
    [Anode_Potential] = mphglobal(model,{'E_anode'});
    [Charging_Time] = mphglobal(model,{'t'});

    [eta_a] = abs(phia - OCP); % Anode Overpotential
    [eta_c] = abs(phis - OCP); 

    [Resistance_a] = (eta_a/I_current); % Anode Resistance (by overpotential)
    [Resistance_c] = (eta_c/I_current);
    
    [Ra] = Resistance_a(:,1); % 원하는 행렬 값 추출
    [Rc] = Resistance_c(:,1);
    [Ia] = I_current(1,:);

    % 단위 환산
    T_ref_degC = (T_ref-273);
    [Charging_Time_min] = (Charging_Time/60) ;

    data = [{C_1D},{D_in},{Ra},{Rc},{SOC_Cylinder},{SOC_Tubular}, {Charging_Time_min}];
    
%     data_saved = array2table(data);
%     data_accum = [data_accum; data_saved];

    myStruct.Crate = [{C_1D}];
    myStruct.Diameter = [{2*D_in}];
    myStruct.Resistance_Anode = [{Ra}];
    myStruct.Resistance_Cathode = [{Rc}];
    myStruct.SOC_Cylinder = [{SOC_Cylinder}];
    myStruct.SOC_Tubular = [{SOC_Tubular}];
    myStruct.Charging_Time = [{Charging_Time_min}];
    myStruct.Cathode_Potential = [{Cathode_Potential}];
    myStruct.Anode_Potential = [{Anode_Potential}];
    
    data_saved = struct2table(myStruct);
    data_accum = [data_accum; data_saved];

   save (['Cell_Result_v4'], "data_accum");

    %     structArray = cell2struct(saved_data);
    %     saved_data = struct('Resistance', Ra, 'SOC', SOC, 'Temperature', Temp, 'C_rate', C_1D);

%% Figure Plot

%     x1 = [D_in];
%     y1 = [SOC];
%     z1 = [C_1D];
% 
%     figure(1)
%     plot3(x1,y1,z1, 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
% 
% 
%     hold on
% 
% 
%     xlabel('Temperature');
%     ylabel('SOC');
%     zlabel('C rate');
% 
%     xlim([0 60])
%     zlim([0 7])
%   
%     
% 
%     x2 = [C_rate];
%     y2 = [SOC];
%     z2 = [Ra];
% 
%     
%     figure(2)
%     plot3(x2,y2,z2, 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
%    
% 
%     hold on
% 
%     xlabel('C rate');
%     ylabel('SOC');
%     zlabel('Resistance Anode');
%     xlim([0 6])
%     ylim([0.15 1])
% 
%     x3 = [C_rate];
%     y3 = [SOC];
%     z3 = [Rc];
% 
%     
%     figure(3)
%     plot3(x3,y3,z3, 'o', 'MarkerSize', 2, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
%    
% 
%     hold on
% 
%     xlabel('C rate');
%     ylabel('SOC');
%     zlabel('Resistance Cathode');
%     xlim([0 6])
%     ylim([0.15 1])

%%
%     x = [C_rate];
%     y = [T_ref_degC];
%     z = [SOC]; 
%     
%     figure(1)
%     plot3(x,y,z,'b');
%     hold on
%    
% 
%     xlabel('C rate');
%     ylabel('Temperature');
%     zlabel('SOC');
%     xlim([0 6]);
%     ylim([0 60]);
%     zlim([0 1]);
%     title('3D Plane');
% 
%     x1 = [C_rate];
%     y1 = [SOC];
%     z1 = [Ra];
% 
%     figure(2)
%     plot3(x1,y1,z1,'b');
%     hold on
%    
% 
%     xlabel('C rate');
%     ylabel('SOC');
%     zlabel('Resistance Anode');
%     xlim([0 6]);
%     ylim([0 60]);
%     zlim([0 1]);
%     title('3D Plane2');



 
    end


end

% end

       


    
     

