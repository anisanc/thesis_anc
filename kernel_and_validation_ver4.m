
function varargout = kernel_and_validation_ver4(varargin)
% KERNEL_AND_VALIDATION_VER4 MATLAB code for kernel_and_validation_ver4.fig
% Last Modified by GUIDE v2.5 05-Apr-2017 16:27:58
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kernel_and_validation_ver4_OpeningFcn, ...
                   'gui_OutputFcn',  @kernel_and_validation_ver4_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kernel_and_validation_ver4 is made visible.
function kernel_and_validation_ver4_OpeningFcn(hObject, eventdata, handles, varargin)
set([handles.axes2_1,handles.axes1_1,handles.axes3_1,handles.axes3_2],'box','on','XTickLabel',{},'YTickLabel',{});
set([handles.axes2_2,handles.axes1_2],'visible','off');
set([handles.axes2_3,handles.axes1_3,handles.axes2_4,handles.axes1_4,handles.axes2_5],'XTickLabel',{},'YTickLabel',{});
z=zoom;     setAllowAxesZoom(z,[handles.axes2_2],false);
p=pan;      setAllowAxesPan(p,[handles.axes2_2],false);
set([handles.popupmenu2_1,handles.popupmenu1_1],'String',...
    {'Well 15/5-7 A','Well 15/6-11 S','Well 15/6-9 S','Well 15/6-12',...
    'Well 16/1-7','Well 16/1-14','Well 16/2-7','Well 16/2-13 A',...
    'Well 16/7-9','Well 15/6-10'});
data = zeros(3,2);
set(handles.uitable1,'Data',data,'ColumnName',{'Category A','Category B'},...
    'RowName',{'Category A','Category B','Total'});

handles.uitable1.Position(3) = handles.uitable1.Extent(3);
handles.uitable1.Position(4) = handles.uitable1.Extent(4);

% Load MAT or DATA
handles.data1=importdata('w15_5_7a.mat');
handles.data2=importdata('w15_6_11s.mat');
handles.data3=importdata('w15_6_9s.mat');
handles.data4=importdata('w15_6_12.mat');
handles.data5=importdata('w16_1_7.mat');
handles.data6=importdata('w16_1_14.mat');
handles.data7=importdata('w16_2_7.mat');
handles.data8=importdata('w16_2_13a.mat');
handles.data9=importdata('w16_7_9.mat');
handles.data10=importdata('w15_6_10.mat');

addpath 'Data_Log\Casing'
addpath 'Data_Log\Formation'
addpath 'Data_Log\data_litho_cutting'

[~,~,handles.data1.formation]=xlsread('data 15_5_7a.xlsx');
[~,~,handles.data2.formation]=xlsread('data 15_6_11s.xlsx');
[~,~,handles.data3.formation]=xlsread('data 15_6_9s.xlsx');
[~,~,handles.data4.formation]=xlsread('data 15_6_12.xlsx');
[~,~,handles.data5.formation]=xlsread('data 16_1_7.xlsx');
[~,~,handles.data6.formation]=xlsread('data 16_1_14.xlsx');
[~,~,handles.data7.formation]=xlsread('data 16_2_7.xlsx');
[~,~,handles.data8.formation]=xlsread('data 16_2_13a.xlsx');
[~,~,handles.data9.formation]=xlsread('data 16_7_9.xlsx');
[~,~,handles.data10.formation]=xlsread('data 15_6_10.xlsx');


[~,~,handles.data1.casing]=xlsread('15_5_7a.xlsx');
[~,~,handles.data2.casing]=xlsread('15_6_11s.xlsx');
[~,~,handles.data3.casing]=xlsread('15_6_9s.xlsx');
[~,~,handles.data4.casing]=xlsread('15_6_12.xlsx');
[~,~,handles.data5.casing]=xlsread('16_1_7.xlsx');
[~,~,handles.data6.casing]=xlsread('16_1_14.xlsx');
[~,~,handles.data7.casing]=xlsread('16_2_7.xlsx');
[~,~,handles.data8.casing]=xlsread('16_2_13a.xlsx');
[~,~,handles.data9.casing]=xlsread('16_7_9.xlsx');
[~,~,handles.data10.casing]=xlsread('15_6_10.xlsx');

%-- ADD new data (cutting)
[~,~,handles.data1.cutting]=xlsread('cutting_15_5_7_A.xlsx');
[~,~,handles.data2.cutting]=xlsread('cutting_15_6_11_S.xlsx');
[~,~,handles.data3.cutting]=xlsread('cutting_15_6_9_S.xlsx');


handles.output = hObject;

% handles.prior           = {'f1',0;'f2',0};
linkaxes([handles.axes3_1,handles.axes3_2],'x');
linkaxes([handles.axes1_1,handles.axes2_1,handles.axes2_4,handles.axes1_4,handles.axes2_5],'y');


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = kernel_and_validation_ver4_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% ========================================================================
% ============================ PANEL 1 ===================================
% ========================================================================

function popupmenu1_1_Callback(hObject, eventdata, handles)
well =get(handles.popupmenu1_1,'Value');
axes(handles.axes1_1);
[handles.train.data]=log_process(handles.axes1_2,...
    well,handles,handles.axes1_3, handles.axes1_4,handles.popupmenu1_2);
linkaxes([handles.axes1_1, handles.axes1_3],'y');
handles.output = hObject;
guidata(hObject, handles);

function popupmenu1_2_Callback(hObject, eventdata, handles)
val= get(hObject,'Value'); string= get(hObject,'String');
hole_size= string(val);

train               = handles.train;
train.data_screen   = train.data(strcmp(train.data(:,3),hole_size)==1,1:6);
train.top           = min(cell2mat(train.data_screen(:,1)));
train.bottom        = max(cell2mat(train.data_screen(:,1)));
[~]                 = filter_and_draw(train.top,...
    train.bottom,train.data,handles.axes1_1);

set(handles.edit1_top,'String',num2str(train.top));
set(handles.edit1_bottom,'String',num2str(train.bottom));
handles.train = train;

handles.output = hObject;
guidata(hObject, handles);
        
function edit1_top_Callback(hObject, eventdata, handles)
handles.train.top           = str2num(get(hObject, 'String'));
handles.train.data_screen   = filter_and_draw(handles.train.top,...
    handles.train.bottom,handles.train.data,handles.axes1_1);
handles.output = hObject;
guidata(hObject, handles);
                       
function edit1_bottom_Callback(hObject, eventdata, handles)
handles.train.bottom = str2num(get(hObject, 'String'));
handles.train.data_screen   = filter_and_draw(handles.train.top,...
    handles.train.bottom,handles.train.data,handles.axes1_1);
handles.output = hObject;
guidata(hObject, handles);

        
% ========================================================================
% ============================ PANEL 2 ===================================
% ========================================================================
function popupmenu2_1_Callback(hObject, eventdata, handles)
well =get(handles.popupmenu2_1,'Value');
axes(handles.axes2_1);
[handles.test.data]=log_process(handles.axes2_2,...
    well,handles,handles.axes2_3,handles.axes2_5,handles.popupmenu2_2);
linkaxes([handles.axes2_1, handles.axes2_3],'y');
handles.output = hObject;
guidata(hObject, handles);

function popupmenu2_2_Callback(hObject, eventdata, handles)
val= get(hObject,'Value'); string= get(hObject,'String');
hole_size   = string(val);
test        = handles.test;
test.data_screen    = test.data(strcmp(test.data(:,3),hole_size)==1,1:6);
test.top            = min(cell2mat(test.data_screen(:,1)));
test.bottom         = max(cell2mat(test.data_screen(:,1)));
[~]                 = filter_and_draw(test.top,...
    test.bottom,test.data,handles.axes2_1);

set(handles.edit2_top,'String',num2str(test.top));
set(handles.edit2_bottom,'String',num2str(test.bottom));

handles.test    = test;
handles.output = hObject;
guidata(hObject, handles);

function edit2_top_Callback(hObject, eventdata, handles)
handles.test.top            = str2num(get(hObject, 'String'));
handles.test.data_screen    = filter_and_draw(handles.test.top,...
    handles.test.bottom,handles.test.data,handles.axes2_1);
handles.output = hObject;
guidata(hObject, handles);

function edit2_bottom_Callback(hObject, eventdata, handles)
handles.test.bottom = str2num(get(hObject, 'String'));
handles.test.data_screen    = filter_and_draw(handles.test.top,...
    handles.test.bottom,handles.test.data,handles.axes2_1);
handles.output = hObject;
guidata(hObject, handles);

% ========================================================================
% ============================ PANEL 3 ================================
% ========================================================================

function button_eval_Callback(hObject, eventdata, handles)

test = handles.test;
train = handles.train;

% -----------------------------------------------------------------------
% Get prior probability from testing data
[prior.shale, prior.not_shale, prior.data_nan, prior.data_good,~] = filter_category (test.data_screen,'geology');
prior.p_shale = length(prior.shale)/length(prior.data_good);
prior.p_not_shale = length(prior.not_shale)/length(prior.data_good);
% Use prior probability or not?
active_button = get(handles.uibuttongroup1,'SelectedObject');
value         = get(active_button,'ListboxTop');

% -----------------------------------------------------------------------
test.data_good = prior.data_good;
test.data_nan = prior.data_nan;
[test.f,test.x] = kernel (cell2mat(test.data_good(:,2)));
% Plot testing data
axes(handles.axes3_1);
delete(findobj(handles.axes3_1,'Type','Line'));
train.line = line(test.x,test.f,'Color','k','LineWidth',1);
set(handles.axes3_1,'Xticklabelmode','auto','Xlimmode','auto',...
    'Yticklabelmode','auto','Ylimmode','auto');
% -----------------------------------------------------------------------

% Filter training data into shale
[train.shale, train.not_shale, train.data_nan, train.data_good, color_group] = filter_category (train.data_screen,'cutting');
% Process kernel
[train.f_shale,train.x_shale] = kernel (cell2mat(train.shale(:,2)));
[train.f_not_shale,train.x_not_shale] = kernel (cell2mat(train.not_shale(:,2)));
% Plot training data kernel
axes(handles.axes3_2); 
delete(findobj(handles.axes3_2,'Type','Line'));
set(handles.axes3_2,'Xticklabelmode','auto','Xlimmode','auto',...
    'Yticklabelmode','auto','Ylimmode','auto');
if value == 1
    train.f_shale = train.f_shale.*0.5;
    train.f_not_shale = train.f_not_shale.*0.5;
else
    train.f_shale = train.f_shale.*prior.p_shale;
    train.f_not_shale = train.f_not_shale.*prior.p_not_shale;
end
train.line_shale = line(train.x_shale,train.f_shale,'Color',color_group(1,:),'LineWidth',1);
hold on
train.line_not_shale = line(train.x_not_shale,train.f_not_shale,'Color',color_group(2,:),'LineWidth',1);

% Find intersection
[X0,Y0] = find_intersection(train.x_shale,train.f_shale,train.x_not_shale,train.f_not_shale,handles.axes3_2);
set(gca,'XLim',[0 250],'fontsize',8);
hold off


ylabel(handles.axes3_1,'Probability Density','fontsize',8,'units','normalized',...
    'position',[0.05 0.5 0]);
ylabel(handles.axes3_2,'Probability Density','fontsize',8,'units','normalized',...
    'position',[0.05 0.5 0]);
xlabel(handles.axes3_1,'Gamma Ray (API)','fontsize',8,'units','normalized',...
    'position',[0.5 0.15 0]);
xlabel(handles.axes3_2,'Gamma Ray (API)','fontsize',8,'units','normalized',...
    'position',[0.5 0.15 0]);

% Show prior and show numberof points and groups selected
N_train = num2str(length(train.data_good));
N_test  = num2str(length(test.data_good));

set(handles.text1_3,'String',{strcat('P(Shale) = ', num2str(prior.p_shale)),...
    strcat('P(not-shale) =',num2str(prior.p_not_shale))},'Fontsize',8);
set(handles.text39,'String',{strcat('N Training = ',N_train),...
    strcat('N Testing = ',N_test)},'Fontsize',8);

% Save the threshold result in table
data_threshold = [X0,Y0];
[n,~]   = size(X0);
set(handles.uitable3,'Data',data_threshold,'ColumnName',{'x','f(x)'},...
        'RowName',num2cell(1:1:n),'ColumnWidth', {60 60});

legend(handles.axes3_2, strcat('f(Shale)'),strcat('f(Not-Shale)'));
legend(handles.axes3_1,'f(Train Data)');


%Save variables to handles
handles.test = test;
handles.train = train;
handles.prior = prior;
handles.color_group = color_group;
assignin('base','training',train);
assignin('base','testing',test);
assignin('base','prior',prior);
assignin('base','threshold',data_threshold);

handles.output = hObject;
guidata(hObject, handles);


function [data1, data2, nan_data, good_data, line_color] = filter_category (data_screen,litho_source)
nan_data = data_screen(strcmp(data_screen(:,6),'NaN')==1,1:6);
good_data = data_screen(strcmp(data_screen(:,6),'NaN')==0,1:6);
if strcmpi(litho_source,'cutting')
    k=6;
else
    k=5;
end
data1 = good_data(strcmp(good_data(:,k),'Shale')==1,1:6);
data2 = good_data(strcmp(good_data(:,k),'Shale')==0,1:6);
line_color = [0.2 0.6 0.4; 0.6 0.4 0];
    
function [data_update] = filter_and_draw(top, bottom, data_gr, axes_plot)
data_update   = data_gr(cell2mat(data_gr(:,1))>=top,1:6);
data_update   = data_update(cell2mat(data_update(:,1))<=bottom,1:6);

axes(axes_plot)
delete (findobj(gca,'Tag','Area'));
rect = rectangle('Position',[0,top,300,(bottom-top)],...
    'FaceColor',[0.859 1 0.859],'Tag','Area','Edgecolor','none');
uistack(rect,'bottom');

% ========================================================================
% ============================ KDE =======================================
% ========================================================================

function [f,x] = kernel(data)
if isempty(data)==0
    [f,x]=ksdensity(data,'kernel','epanechnikov','npoints',2000);
else
    f = [];
    x = [];
end


function [X0,Y0] = find_intersection(x1,y1,x2,y2,the_axes)
delete(findobj(the_axes,'Color',[1 0.4 0]));
if isempty(x1)==0 & isempty(x2)==0
    [X0,Y0,~,~] = intersections(x1,y1,x2,y2,1);
    axes(the_axes)
    for n=1:length(X0)
        line([X0(n),X0(n)],[0 ,Y0(n)],'Color',[1 0.4 0]);
    end
else
    X0=[]; Y0=[];
end


function [result]= pushbutton1_Callback(hObject, eventdata, handles)
[result,TCM,test]= show_result(handles.test,handles.train,handles.uitable1,handles.text42,handles);
assignin('base','testing',test);
assignin('base','TCM',TCM);
assignin('base','result',result);
guidata(hObject, handles);

function [summary,TCM,test] = show_result (test,train,eval_table,eval_text,handles)
positiveA = 0 ;
negativeA = 0;
positiveB = 0;
negativeB = 0;
f_shale = zeros(length(test.data_good),1);
f_not_shale =zeros(length(test.data_good),1);
R =zeros(length(test.data_good),1);
prediction =cell(length(test.data_good),1);

for i=1:length(test.data_good)
%     depth            = cell2mat(test.data_good(i,1));
    gr               = cell2mat(test.data_good(i,2));
    %--- check shale
    if isempty(train.f_shale)==0
        [~,a]  = min(abs(train.x_shale-gr));
        f_shale(i)   = train.f_shale(a);
    end
    
    %--- check not-shale
    if isempty(train.f_not_shale)==0
        [~,a]  = min(abs(train.x_not_shale-gr));
        f_not_shale(i)   = train.f_not_shale(a);
    end
    
%  calculate ratio
    R(i)    = f_shale(i)/f_not_shale(i);
    
%  check category without prior
    if R(i) > 1 | R(i) == inf 
        prediction {i} = 'Shale';
%         color    = {handles.color_group(1,:)};
        if strcmpi(test.data_good(i,6),'Shale')
            positiveA = positiveA + 1;
        else
            negativeA = negativeA +1;
        end
    else
        prediction {i} = 'Not-Shale';
%         color    = {handles.color_group(2,:)};
        if strcmpi(test.data_good(i,6),'Shale')~=1
            positiveB = positiveB + 1;
        else
            negativeB = negativeB +1;
        end
    end
%      result(i,:)=[num2cell(depth),num2cell(gr),category,color,num2cell(R)];
    
end
% Show Bayes table result
summary = [ positiveA, negativeA ; negativeB, positiveB;...
    (positiveA+negativeA), (positiveB+negativeB)];
set(eval_table,'Data',summary);
TCM = round(((negativeA+negativeB)/...
    (negativeA+negativeB+positiveA+positiveB)*100),2);
set(eval_text,'String',strcat(num2str(TCM),' %'));

% PLOT THE NEW LITHOLOGY
plot_result_lithology(cell2mat(test.data_good(:,1)),prediction,handles);
test.result = table(test.data_good(:,1),test.data_good(:,2),...
    test.data_good(:,3),test.data_good(:,4),test.data_good(:,5),...
    test.data_good(:,6),f_shale,f_not_shale,R,prediction,...
    'VariableNames',{'Depth' 'GR' 'Section' 'Formation' 'Geology_Data'...
    'Cutting_Data' 'Shale_Frequency' 'Sand_Frequncy' 'Ratio' 'Prediction'});

function plot_result_lithology(depth,lithology,handles)
cla(handles.axes2_4);
axes(handles.axes2_4);
top             = depth(1);
type_lithology  = lithology(1);
x = 0;
w=0.2;

for i=2 : length(depth)
    if strcmp(type_lithology,lithology(i))==0 | i==length(depth)
        bottom  = depth(i);
        litho_zone= rectangle('Position',[x,top,w,(bottom-top)],'EdgeColor','none');
        if strcmp(type_lithology,'Shale')==1
            set(litho_zone,'FaceColor','g');
        else
            set(litho_zone,'FaceColor',[0.6 0.4 0]);
        end    
        top     = depth(i);
        type_lithology = lithology(i);
    end
end
set(handles.axes2_4,'ydir','reverse','YTick',[],'XTick',[],'XLim',[0 0.2],'YLim',...
    [0 5000],'YColor','none','XColor','none','Color',[0.933 0.933 0.933]);

% ========================================================================
% ============================ PLOTTING LOG ==============================
% ========================================================================
    
function [gamma_ray] =log_process (legend, well_number, handles, litho_axes, litho_axes_2, popupmenu)
cla(gca,'reset');
cla(litho_axes,'reset');
cla(litho_axes_2,'reset');
hold off
set(legend,'Visible','off','Xscale','linear');
xlabel(legend,'');
set(gca,'YTickLabelMode','auto','YLim',[0 5000],'XLim',[0 250],'YDir','reverse',...
     'Xgrid','on','XTick',[0:50:250],'XTickLabel',{},'XScale','linear',...
     'box','on','fontsize',8);

%===================== get the data (x and y) ============================
well = eval(strcat('handles.data',num2str(well_number)));
data = well.curves;
name = well.curve_info;
casing = well.casing;
formation = well.formation;
cutting = well.cutting;

casing(1:2,:)=[]; 
formation(1,:)=[];
cutting(1,:) = [];
curve_pos = find(strcmp('GR',name(:,3)));
gr_tmp = [data(:,1),data(:,curve_pos)];
gr_tmp = gr_tmp(isnan(gr_tmp(:,2))==0,1:2);
y = gr_tmp(:,1); x = gr_tmp(:,2);

[gamma_ray] = data_screen(y,x,formation,casing,cutting);

%========================= put the string to popupmenu====================
hole_size = casing(:,1);
set(popupmenu,'String',hole_size);

%========================= plot the log data =============================
color = get(gca,'ColorOrder');
log_line = line(x(~isnan(x)),y(~isnan(x)),'Color',color(1,:),'Linewidth',1);
set(log_line,'Tag','Gamma Ray (GAPI)','ButtonDownFcn',@buttonDownCallback);
set(gca,'fontsize',8,'XLim',[0 250]);
ylabel(gca,'Depth (m)','fontsize',8,'units','normalized',...
    'position',[0.1 0.5 0]);
% ========================== plot the legend =============================
xlabel(legend,'Gamma Ray (GAPI)','fontsize',8);
label_tick=(get(gca,'XTick'));
set(legend,'YTick',[],'XTickLabel',label_tick,...
        'Color','none','box','off','XAxisLocation','bottom',...
        'XLim',[0 250],'XTick',get(gca,'XTick'),'fontsize',8,...
        'Visible','on','YColor','none','XColor',color(1,:));
linkaxes([gca,legend],'x'); 
plotting_formation_casing (formation, casing, litho_axes);
plotting_cutting(y, cutting, litho_axes_2);

function [data_gamma_ray] = data_screen(depth,gamma_ray,formation,casing, cutting)
% =================== SCREENING LITHOLOGY AND FORMATION ==================
for i=1:length(formation) 
    top = cell2mat(formation(i,3));
    bottom = cell2mat(formation(i,4));
    a = find(depth==top);
    b = find(depth==bottom);
    if isempty(a)==1
        [~,a]=min(abs(depth-top));
    end
    if isempty(b)==1
        [~,b]=min(abs(depth-bottom));
    end
    
    if i==length(formation)
        if b~=length(depth)
            b=length(depth);
        end
    end
    tmp(:,1)=depth(a:b)';
    tmp(:,2)=gamma_ray(a:b)';

    litho_name(a:b)=formation(i,5);
    formation_name(a:b)=formation(i,2);
    clear tmp
end
formation_name=formation_name';
litho_name=litho_name';

% SCREENING CUTTING DATA
cutting_name=cell(length(depth),1);
for i=1:length(cutting) 
    top = cell2mat(cutting(i,1));
    bottom = cell2mat(cutting(i,2));
    a = find(depth==top);
    b = find(depth==bottom);
    if isempty(a)==1
        [~,a]=min(abs(depth-top));
    end
    if isempty(b)==1
        [~,b]=min(abs(depth-bottom));
    end
    
    if i==1
       if a~=1
           cutting_name(1:a-1)={'NaN'};
       end
    end
    
    if i==length(cutting)
        if b~=length(depth)
            b=length(depth);
        end
    end
    cutting_name(a:b)=cutting(i,4);
end


% ====================== SCREENING BOREHOLE SIZE =========================
top = cell2mat(formation(1,3));
[l,~] = size(casing);
for i=1:l
    bottom = cell2mat(casing(i,5));
    [~,a]=min(abs(depth-top));
    [~,b]=min(abs(depth-bottom));
    hole_size(a:b)=casing(i,1);  
    top = bottom;
end
if b<length(depth)
    hole_size(b+1:length(depth))=casing(i,1);
end
 hole_size=hole_size';
 data_gamma_ray=[num2cell(depth),num2cell(gamma_ray),hole_size,formation_name,litho_name,cutting_name];

% ADD THIS
function plotting_cutting (depth, cutting, litho_axes)
x = 0.2;
w = 0.8;
if cell2mat(cutting(1,1))> depth(1)
    tmp=[{depth(1)},cutting(1,1),{'NaN'},{'NaN'};cutting];
    cutting=tmp;
end
axes(litho_axes)    
for i=1:length(cutting)
    top = cell2mat(cutting(i,1));
    bottom = cell2mat(cutting(i,2));
    litho_zone=rectangle('Position',[x,top,w,(bottom-top)]);

% Checking litholohy type, set color based on lithology    
    if strcmp(cutting(i,4),'Sandstone')==1
        set(litho_zone,'FaceColor','y');
    else if strcmp(cutting(i,4),'Shale')==1
        set(litho_zone,'FaceColor','g');
        else if strcmp(cutting(i,4),'Chalk')==1
                set(litho_zone,'FaceColor',[0.2 0.2 0.6]);
            else if strcmp(cutting(i,4),'Carbonate')==1
                    set(litho_zone,'FaceColor',[0.301 0.745 0.933]);
            else if strcmp(cutting(i,4),'Coal')==1
                    set(litho_zone,'FaceColor',[0 0 0]);
                    else if strcmp(cutting(i,4),'NaN')==1
                    set(litho_zone,'FaceColor',[1 1 1]);
                        end
                  end
                end
            end
        end
    end
    hold on
end
set(litho_axes,'ydir','reverse','YTick',[],'XTick',[],'XLim',[0 1],'YLim',...
    [0 5000],'YColor','none','XColor','none','Color',[0.933 0.933 0.933]);


function plotting_formation_casing (formation, casing, litho_axes)
% plotting the formation group
line_formation(formation);
x = 0.6; w = 0.2;
top = cell2mat(formation(1,3)); bottom = cell2mat(formation(1,4));

axes(litho_axes)
for i=2:(length(formation)) 
    if strcmp(formation(i,1),formation(i-1,1))==1
        if top>cell2mat(formation(i,3))
            top=cell2mat(formation(i,3));
        else if cell2mat(formation(i,4))>bottom
                bottom = cell2mat(formation(i,4));
            end
        end
    end
    
    if strcmp(formation(i,1),formation(i-1,1))==0
        title   = formation(i-1,1);
        square  = rectangle('Position',[x,top,w,(bottom-top)],'FaceColor','w');
        data    = {top,bottom,title};
        set(square,'ButtonDownFcn',@LithoCallback,'Userdata',data);
        if (bottom-top)>500
            text((x+w/2),(top+(bottom-top)/2),title,'HorizontalAlignment','center',...
                'Rotation',-90,'fontsize',7,'Clipping','on','ButtonDownFcn',@LithoCallback,'Userdata',data);
        end       
        top=cell2mat(formation(i,3)); bottom=cell2mat(formation(i,4));
    end
    
    if i==length(formation)
        title   = formation(i,1);
        square  = rectangle('Position',[x, top,w,(bottom-top)],'FaceColor','w');
        data    = {top,bottom,title};
        set(square,'ButtonDownFcn',@LithoCallback,'Userdata',data);
        if (bottom-top)>500
             text((x+w/2),(top+(bottom-top)/2),title,'HorizontalAlignment','center',...
                 'Rotation',-90,'fontsize',7,'Clipping','on','ButtonDownFcn',@LithoCallback,'Userdata',data);
        end
    end
end
hold on

x = 0.8;
for i=1:length(formation)
    top = cell2mat(formation(i,3));   bottom = cell2mat(formation(i,4));
    litho_zone=rectangle('Position',[x,top,w,(bottom-top)]);
    data= [top,bottom,formation(i,2),formation(i,5)];    
    set(litho_zone,'ButtonDownFcn',@LithoCallback,'Userdata',data);

% Checking litholohy type, set color based on lithology    
    if strcmp(formation(i,5),'Sandstone')==1
        set(litho_zone,'FaceColor','y');
    else if strcmp(formation(i,5),'Shale')==1
        set(litho_zone,'FaceColor','g');
        else if strcmp(formation(i,5),'Chalk')==1
                set(litho_zone,'FaceColor',[0.2 0.2 0.6]);
            else if strcmp(formation(i,5),'Carbonate')==1
                    set(litho_zone,'FaceColor',[0.301 0.745 0.933]);
                end
            end
        end
    end
end

% ============================ PLOT CASING ===============================
[a,~] = size(casing); seawater = cell2mat(formation(1,3));

for i=1:a
    x = [(0.55-0.45/a*i),(0.55-0.45/a*i)];
    y = [seawater, cell2mat(casing(i,5))];
    the_line=line(x,y,'Linewidth',3,'Color','b');
    set(the_line,'ButtonDownFcn',@CasingCallback,'Userdata',casing(i,:));
end

set(litho_axes,'ydir','reverse','YTick',[],'XTick',[],'XLim',[0 1],'YLim',...
    [0 5000],'YColor','none','XColor','none','Color',[0.933 0.933 0.933]);
hold off

function LithoCallback(o,e)
pos = get(gca,'CurrentPoint');
pos = pos(1,1:2);
prev = findobj(gca,'Type','text','-and','Tag','pop_note');
delete(prev);
data = get(gco,'Userdata');
str2=strcat('Top = ',num2str(cell2mat(data(1))),' mMD');
str3=strcat('Bottom = ',num2str(cell2mat(data(2))),' mMD');
% if length(data)==4
%     str4=strcat('Lithology = ',char(data(4)));
%     text(pos(1)-0.6,pos(2),{data{3},str2,str3,str4},'FontSIze',7.5,...
%         'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');
% else
    text(pos(1)-0.7,pos(2),{char(data{3}),str2,str3},'FontSize',7.5,...
        'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');


function line_formation(formation)
for i=1: length(formation)
    x = [ 0 500];
    y = [cell2mat(formation(i,3)),cell2mat(formation(i,3))];
    line(x,y,'LineStyle',':','Linewidth',0.2,'Color',[0.4 0.4 0.6]);
end

function CasingCallback(o,e)
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
prev = findobj(gca,'Type','text','-and','Tag','pop_note'); delete(prev);
data = get(gco,'Userdata');
str1=char(data(3));
if isnan(cell2mat(data(2)))==1
    str2=strcat('Size = -');
else
    str2=strcat('Size = ',char(data(2)));
end
str3=strcat('Shoe = ',num2str(cell2mat(data(5))),' mMD');
text(pos(1),pos(2),{str1,str2,str3},'FontSize',7.5,...
    'Backgroundcolor',[1 1 0.7],'Clipping','off','Tag','pop_note','EdgeColor','r');

function buttonDownCallback(obj,event)
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
color = get(gco,'Color');
prev = findobj(gca,'Type','text'); delete(prev);
text(pos(1),pos(2),{get(gco,'Tag'),num2str(pos(1)),num2str(pos(2))},...
    'EdgeColor',color,'FontSIze',8,'Backgroundcolor','w','Clipping','on');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
