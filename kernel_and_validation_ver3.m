
function varargout = kernel_and_validation_ver3(varargin)
% KERNEL_AND_VALIDATION_VER3 MATLAB code for kernel_and_validation_ver3.fig
% Last Modified by GUIDE v2.5 19-Oct-2016 12:24:16
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kernel_and_validation_ver3_OpeningFcn, ...
                   'gui_OutputFcn',  @kernel_and_validation_ver3_OutputFcn, ...
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


% --- Executes just before kernel_and_validation_ver3 is made visible.
function kernel_and_validation_ver3_OpeningFcn(hObject, eventdata, handles, varargin)
set([handles.axes2_1,handles.axes1_1,handles.axes0_1,handles.axes3_1,handles.axes3_2],'box','on','XTickLabel',{},'YTickLabel',{});
set([handles.axes2_2,handles.axes1_2,handles.axes0_2],'visible','off');
set([handles.axes2_3,handles.axes1_3,handles.axes0_3,handles.axes2_4],'XTickLabel',{},'YTickLabel',{});
z=zoom;     setAllowAxesZoom(z,[handles.axes2_2],false);
p=pan;      setAllowAxesPan(p,[handles.axes2_2],false);
set([handles.popupmenu2_1,handles.popupmenu1_1,handles.popupmenu0_1],'String',...
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
handles.output = hObject;

% handles.prior           = {'f1',0;'f2',0};
linkaxes([handles.axes3_1,handles.axes3_2],'x');
linkaxes([handles.axes1_1,handles.axes2_1,handles.axes0_1,handles.axes2_4],'y');


% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = kernel_and_validation_ver3_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% ========================================================================
% ============================ PANEL 0 ===================================
% ========================================================================


function popupmenu0_1_Callback(hObject, eventdata, handles)
well =get(handles.popupmenu0_1,'Value');
axes(handles.axes0_1);
[handles.prior.data]=log_process(handles.axes0_2,...
    well,handles,handles.axes0_3,handles.popupmenu0_2);
linkaxes([handles.axes0_1, handles.axes0_3],'y');
handles.output = hObject;
guidata(hObject, handles);

function popupmenu0_2_Callback(hObject, eventdata, handles)
val= get(hObject,'Value'); string= get(hObject,'String');
hole_size= string(val);

prior               = handles.prior;
prior.data_screen   = prior.data(strcmp(prior.data(:,3),hole_size)==1,1:5);
prior.top           = min(cell2mat(prior.data_screen(:,1)));
prior.bottom        = max(cell2mat(prior.data_screen(:,1)));
[~]                 = filter_and_draw(prior.top,...
    prior.bottom,prior.data,handles.axes0_1);

set(handles.edit0_top,'String',num2str(prior.top));
set(handles.edit0_bottom,'String',num2str(prior.bottom));
handles.prior = prior;

handles.output = hObject;
guidata(hObject, handles);

function edit0_top_Callback(hObject, eventdata, handles)
handles.prior.top           = str2num(get(hObject, 'String'));
handles.prior.data_screen   = filter_and_draw(handles.prior.top,...
    handles.prior.bottom,handles.prior.data,handles.axes0_1);
handles.output = hObject;
guidata(hObject, handles);

function edit0_bottom_Callback(hObject, eventdata, handles)
handles.prior.bottom        = str2num(get(hObject, 'String'));
handles.prior.data_screen   = filter_and_draw(handles.prior.top,...
    handles.prior.bottom,handles.prior.data,handles.axes0_1);
handles.output = hObject;
guidata(hObject, handles);


% ========================================================================
% ============================ PANEL 1 ===================================
% ========================================================================

function popupmenu1_1_Callback(hObject, eventdata, handles)
well =get(handles.popupmenu1_1,'Value');
axes(handles.axes1_1);
[handles.train.data]=log_process(handles.axes1_2,...
    well,handles,handles.axes1_3,handles.popupmenu1_2);
linkaxes([handles.axes1_1, handles.axes1_3],'y');
handles.output = hObject;
guidata(hObject, handles);

function popupmenu1_2_Callback(hObject, eventdata, handles)
val= get(hObject,'Value'); string= get(hObject,'String');
hole_size= string(val);

train               = handles.train;
train.data_screen   = train.data(strcmp(train.data(:,3),hole_size)==1,1:5);
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
    well,handles,handles.axes2_3,handles.popupmenu2_2);
linkaxes([handles.axes2_1, handles.axes2_3],'y');
handles.output = hObject;
guidata(hObject, handles);

function popupmenu2_2_Callback(hObject, eventdata, handles)
val= get(hObject,'Value'); string= get(hObject,'String');
hole_size   = string(val);
test        = handles.test;
test.data_screen    = test.data(strcmp(test.data(:,3),hole_size)==1,1:5);
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
% FILTER DATA CATEGORY A and B
% Checking which radio button active
active_RB   = get(handles.uibuttongroup3,'SelectedObject');
value       = get(active_RB,'ListboxTop');

% Filter test data
test = handles.test;
[test.data1, test.data2, ~] = filter_category (test.data_screen,value);

% Filter training data
train = handles.train;
[train.data1, train.data2, f, color_group] = filter_category (train.data_screen,value);
% Get kernel source data (SELECT GROUP CATEGORY)
if (get(handles.kernel2,'Value'))==1
    train.data1     = [test.data1;train.data1];
    train.data2     = [test.data2;train.data2];
end

% Calculate the kernel density and plot the results
[handles.line_testA, handles.line_testB, test.thX, test.thY] = plot_kernel(handles.axes3_1,...
    test.data1, test.data2,color_group);
[handles.line_trainA, handles.line_trainB, ~, ~] = plot_kernel(handles.axes3_2,...
    train.data1, train.data2,color_group);

ylabel(handles.axes3_1,'Probability Density','fontsize',8,'units','normalized',...
    'position',[0.05 0.5 0]);
ylabel(handles.axes3_2,'Probability Density','fontsize',8,'units','normalized',...
    'position',[0.05 0.5 0]);
xlabel(handles.axes3_1,'Gamma Ray (API)','fontsize',8,'units','normalized',...
    'position',[0.5 0.15 0]);
xlabel(handles.axes3_2,'Gamma Ray (API)','fontsize',8,'units','normalized',...
    'position',[0.5 0.15 0]);

% Use prior probability or not? And update the train line
active_RB = get(handles.uibuttongroup1,'SelectedObject');
value     = get(active_RB,'ListboxTop');
[train.thX, train.thY ,handles.prior] = radio_button_prior(value,handles);


% Show prior and show number of points and groups selected
N_train = num2str(length(train.data_screen));
N_test  = num2str(length(test.data_screen));
set(handles.text1_3,'String',{strcat('P(',f{1},')   = ', num2str(handles.prior.calc(1))),...
    strcat('P(',f{2},') =',num2str(handles.prior.calc(2))),'',strcat('Group A = ',f{1}),...
    strcat('Group B = ',f{2})},'Fontsize',8);
set(handles.text39,'String',{strcat('N Training = ',N_train),...
    strcat('N Testing = ',N_test)},'Fontsize',8);

% Save the threshold result in table
thresholdX      = {'train.thX', 'test.thX'};
thresholdY      = {'train.thY', 'test.thY'};
table_handles   = [handles.uitable3,handles.uitable4];
for i=1:2
    [n,~]   = size(eval(thresholdX{i}));
    val     = 1:1:n;
    data_threshold = [round(eval(thresholdX{i}),2),eval(thresholdY{i})];
    set(table_handles(i),'Data',data_threshold,'ColumnName',{'x','f(x)'},...
        'RowName',num2cell(val),'ColumnWidth', {60 60});
end

% Plot the legend
% legend(handles.axes3_2, strcat('f(',f{1},')'),strcat('f(',f{2},')'),'Threshold');
% legend(handles.axes3_1, strcat('f(',f{1},')'),strcat('f(',f{2},')'),'Threshold');

legend(handles.axes3_2, strcat('f(',f{1},')'),strcat('f(',f{2},')'));
legend(handles.axes3_1, strcat('f(',f{1},')'),strcat('f(',f{2},')'));


%Save variables to handles
handles.test = test; handles.train =train;
handles.f = f; handles.color_group = color_group;
assignin('base','trainA',handles.line_trainA);
assignin('base','trainB',handles.line_trainB);
assignin('base','testA',handles.line_testA);
assignin('base','testB',handles.line_testB);
assignin('base','th_train_x',train.thX);
assignin('base','th_train_y',train.thY);
assignin('base','th_test_x',test.thX);
assignin('base','th_test_y',test.thX);

handles.output = hObject;
guidata(hObject, handles);

function [data1, data2, f, line_color] = filter_category (data_screen,value)
if value ==2
    data1   =data_screen(strcmp(data_screen(:,5),'Sandstone')==1,1:5);
    data2   =data_screen(strcmp(data_screen(:,5),'Sandstone')==0,1:5);
    f = {'Sandstone','Not sand'};
    line_color = [1 1 0; 0.4 0.4 0.6];
else if value == 3
        data1   =data_screen(strcmp(data_screen(:,5),'Shale')==1,1:5);
        data2   =data_screen(strcmp(data_screen(:,5),'Shale')==0,1:5);
        f = {'Shale','Not shale'};
        line_color = [0 1 0; 0.502 0.502 0.502];
    end
end
    
function [data_update] = filter_and_draw(top, bottom, data_gr, axes_plot)
data_update   = data_gr(cell2mat(data_gr(:,1))>=top,1:5);
data_update   = data_update(cell2mat(data_update(:,1))<=bottom,1:5);

axes(axes_plot)
delete (findobj(gca,'Tag','Area'));
rect = rectangle('Position',[0,top,300,(bottom-top)],...
    'FaceColor',[0.859 1 0.859],'Tag','Area','Edgecolor','none');
uistack(rect,'bottom');

% ========================================================================
% ============================ KDE =======================================
% ========================================================================

function [line_f1, line_f2, X0, Y0] = plot_kernel (axes_plot,data_1,data_2,line_color)
axes(axes_plot); 
delete(findobj(gca,'Type','Line'));
set(gca,'Xticklabelmode','auto','Xlimmode','auto',...
    'Yticklabelmode','auto','Ylimmode','auto');

if isempty(data_1)==0
    [f1,x1]=ksdensity(cell2mat(data_1(:,2)),'kernel','epanechnikov','npoints',2000);
    f1=f1.*0.5;
    line_f1 = line(x1,f1,'Color',line_color(1,:),'LineWidth',1);
    hold on
else
    line_f1 =[];
end

if isempty(data_2)==0
    [f2,x2]=ksdensity(cell2mat(data_2(:,2)),'kernel','epanechnikov','npoints',2000);
    f2=f2.*0.5;
    line_f2 = line(x2,f2,'Color',line_color(2,:),'LineWidth',1);
else
    line_f2 =[];
    x2=[]; f2 = [];
end
[X0,Y0] = find_intersection(x1,f1,x2,f2,axes_plot);
set(gca,'XLim',[0 250],'fontsize',8);

function [X0,Y0] = find_intersection(x1,y1,x2,y2,the_axes)
delete(findobj(the_axes,'Color',[1 0.4 0]));
if isempty(x1)==0 & isempty(x2)==0
    [X0,Y0,~,~] = intersections(x1,y1,x2,y2,1);
    axes(the_axes)
    for n=1:length(X0)
%         line([X0(n),X0(n)],[0 ,Y0(n)],'Color',[1 0.4 0]);
    end
else
    X0=[]; Y0=[];
end

function [X0,Y0,prior] = radio_button_prior(radio_number,handles)
% Calculate prior from Panel 0
active_RB   = get(handles.uibuttongroup3,'SelectedObject');
value       = get(active_RB,'ListboxTop');
prior = handles.prior;
[prior.data1, prior.data2, ~, ~] = filter_category (prior.data_screen,value);
prior.calc(1) = round((length(prior.data1)/(length(prior.data1)+length(prior.data2))),3);
prior.calc(2) = round((length(prior.data2)/(length(prior.data1)+length(prior.data2))),3);

fx1_y=get(handles.line_trainA,'YData');
fx2_y=get(handles.line_trainB,'YData');
fx1_x=get(handles.line_trainA,'XData');
fx2_x=get(handles.line_trainB,'XData');

if radio_number==2
    fx1_y= fx1_y./0.5.*prior.calc(1);
    fx2_y = fx2_y./0.5.*prior.calc(2);
    axes(handles.axes3_2);
    set(handles.line_trainA,'YData',fx1_y,'Visible','on'); hold on
    set(handles.line_trainB,'YData',fx2_y,'Visible','on');
    ylabel(handles.axes3_2,'Probability Density x P','fontsize',8,'units','normalized',...
    'position',[0.05 0.5 0]);
    drawnow
    [X0,Y0] = find_intersection(fx1_x,fx1_y,fx2_x,fx2_y,handles.axes3_2);
    
else if radio_number==3
        set(handles.text15,'Visible','Off');
        prior_fx1 = str2num(get(handles.edit4,'String'));
        prior_fx2 = str2num(get(handles.edit5,'String'));
        if(prior_fx1+prior_fx2)==1
            fx1_y=fx1_y./0.5.*prior_fx1;
            fx2_y=fx2_y./0.5.*prior_fx2;
            axes(handles.axes3_2);
            set(handles.line_trainA,'YData',fx1_y,'Visible','on'); hold on
            set(handles.line_trainB,'YData',fx2_y,'Visible','on');
            ylabel(handles.axes3_2,'Probability Density x P','fontsize',8,'units','normalized',...
                'position',[0.05 0.5 0]);
            drawnow
            [X0,Y0] = find_intersection(fx1_x,fx1_y,fx2_x,fx2_y,handles.axes3_2);
        else
            set(handles.text15,'Visible','On');
        end
    else if radio_number==1
            [X0,Y0] = find_intersection(fx1_x,fx1_y,fx2_x,fx2_y,handles.axes3_2);
        end
    end
    
end


function [result]= pushbutton1_Callback(hObject, eventdata, handles)
data        = handles.test.data_screen;
% the_line    = {'handles.line_fx1', 'handles.line_fx2'};
the_line    = {'handles.line_trainA', 'handles.line_trainB'};
[handles.TCM.no_prior]= show_result(data,the_line,handles.uitable1,handles.text42,handles.axes2_4,handles);

guidata(hObject, handles);

function [TCM] = show_result (data,the_line,eval_table,eval_text,eval_axes,handles)
positiveA = 0 ; negativeA = 0; positiveB = 0; negativeB = 0;
for i=1:length(data)
    depth            = cell2mat(data(i,1));
    gr               = cell2mat(data(i,2));
    for j=1:2        
        if isempty(eval(the_line{j}))==0
            line_selected = eval(the_line{j});
            yaxis   = get(line_selected,'YData');
            xaxis   = get(line_selected,'XData');
            [~,a]   = min(abs(xaxis-gr));
            fx(j)   = yaxis(a);
        else
            fx(j) = 0;
        end
    end
    
    % calculate ratio
    R    = fx(1)/fx(2);
     
    % check category without prior
    if R > 1 | R == inf | isnan(R) ==1
        category = handles.f{1};
        color    = {handles.color_group(1,:)};
        if strcmp(data(i,5),handles.f{1})==1
            positiveA = positiveA + 1;
        else
            negativeA = negativeA +1;
        end
    else
        category = handles.f{2};
        color    = {handles.color_group(2,:)};
        if strcmp(data(i,5),handles.f{1})~=1
            positiveB = positiveB + 1;
        else
            negativeB = negativeB +1;
        end
    end
     result(i,:)=[num2cell(depth),num2cell(gr),category,color,num2cell(R)];
    
end
% Show Bayes table result
summary = [ positiveA, negativeA ; negativeB, positiveB;...
    (positiveA+negativeA), (positiveB+negativeB)];
set(eval_table,'Data',summary);
TCM = round(((negativeA+negativeB)/...
    (negativeA+negativeB+positiveA+positiveB)*100),2);
set(eval_text,'String',strcat(num2str(TCM),' %'));

% PLOT THE NEW LITHOLOGY
axes(eval_axes);
plot_result_lithology(cell2mat(result(:,1)),result(:,3),result(:,4));

function plot_result_lithology(depth, lithology, color)
cla(gca);
top             = depth(1);
type_lithology  = lithology(1);
x = 0; w=0.2;

for i=2 : length(depth)
    if strcmp(type_lithology,lithology(i))==0 | i==length(depth)
        bottom  = depth(i);
        rectangle('Position',[x,top,w,(bottom-top)],'FaceColor',cell2mat(color(i-1)),'EdgeColor','none');
        top     = depth(i);
        type_lithology = lithology(i);
    end
end
set(gca,'ydir','reverse','YTick',[],'XTick',[],'XLim',[0 0.2],'YLim',...
    [0 5000],'YColor','none','XColor','none','Color',[0.933 0.933 0.933]);

% ========================================================================
% ============================ PLOTTING LOG ==============================
% ========================================================================
    
function [gamma_ray] =log_process (legend, well_number, handles, litho_axes, popupmenu)
cla(gca,'reset'); cla(litho_axes,'reset'); hold off
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

casing(1:2,:)=[]; formation(1,:)=[];
curve_pos = find(strcmp('GR',name(:,3)));
gr_tmp = [data(:,1),data(:,curve_pos)];
gr_tmp = gr_tmp(isnan(gr_tmp(:,2))==0,1:2);
y = gr_tmp(:,1); x = gr_tmp(:,2);

[gamma_ray] = data_screen(y,x,formation,casing);

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

function [data_gamma_ray] = data_screen(depth,gamma_ray,formation,casing)
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
 data_gamma_ray=[num2cell(depth),num2cell(gamma_ray),hole_size,formation_name,litho_name];

function plotting_formation_casing (formation, casing, litho_axes)
% plotting the formation group
line_formation(formation);
x = 0.8; w = 0.2;
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

x = 0.6;
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
pos = get(gca,'CurrentPoint'); pos = pos(1,1:2);
prev = findobj(gca,'Type','text','-and','Tag','pop_note'); delete(prev);
data = get(gco,'Userdata');
str2=strcat('Top = ',num2str(cell2mat(data(1))),' mMD');
str3=strcat('Bottom = ',num2str(cell2mat(data(2))),' mMD');
if length(data)==4
    str4=strcat('Lithology = ',char(data(4)));
    text(pos(1)-0.6,pos(2),{data{3},str2,str3,str4},'FontSIze',7.5,...
        'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');
else
    text(pos(1)-0.7,pos(2),{char(data{3}),str2,str3},'FontSize',7.5,...
        'Backgroundcolor',[1 1 0.7],'Clipping','on','Tag','pop_note','EdgeColor','r');
end

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
% function pushbutton6_Callback(hObject, eventdata, handles)
% get

% % Get the output from radiobutton
% active_RB1 = get(handles.uibuttongroup1,'SelectedObject');
% active_RB2 = get(handles.uibuttongroup1,'SelectedObject');
% 
% if active_RB1.ListboxTop == 1 & active_RB2.ListboxTop == 1
%     % Showing TCM result
%     TCM = round(handles.TCM.no_prior,2);
%     assignin('base','TCM',TCM);
%     
%     
%     % Create the table of experiments (in this case, group A is assumed sand
%     % and group B is non-sand)
%     data = [num2cell(get(handles.uitable1,'Data'));{strcat(num2str(TCM),'\%')},{strcat(num2str(TCM),'\%')}];
%     T.data = cell2table(data);
%     T.data.Properties.VariableNames = {'Actual_shale','Actual_non_shale'};
%     T.tableRowLabels = {'Predicted shale','Predicted non-shale','Total','TCM'};
%     T.dataFormat     = {'%.0f'};
%     T.tableBorders = 0;
%     table_latex = latexTable(T);
%     assignin('base','table_latex',table_latex);
%     assignin('base','T',T.data);
%     
% 
%     % Create table with description of testing data
%     R{1} = handles.popupmenu2_1.String{handles.popupmenu2_1.Value};
%     R{2} = handles.popupmenu2_2.String{handles.popupmenu2_2.Value};
%     R{3} = strcat(num2str(handles.test.top),' - ',' ',num2str(handles.test.bottom),' m');
%     R{4} = num2str(length(handles.test.data_screen));
%     summary.data = cell2table(R);
%     summary.data.Properties.VariableNames = {'Well' 'Section' 'Depth' 'N'};
%     summary.tableBorders = 0;
%     summary_table = latexTable(summary);
%     assignin('base','summary',summary_table);
%     
%     % Create threshold table
%     y1=get(handles.line_fx1,'YData');
%     y2=get(handles.line_fx2,'YData');
%     x1=get(handles.line_fx1,'XData');
%     x2=get(handles.line_fx2,'XData');
%     if isempty(x1)==0 & isempty(x2)==0
%         [X0,Y0,~,~] = intersections(x1,y1,x2,y2,1);
%         [n,~] = size(X0);
%     end
%     val = [1:1:n];
%     threshold = array2table([val',X0,Y0],'VariableNames',{'No' 'x' 'fx'});
%     S.data = threshold;
%     S.tableBorders = 0;
%     S.dataFormat = {'%.0f',1,'%.2f',1,'%.3f',1};
%     S_table = latexTable(S);
%     assignin('base','threshold',S_table);
% 
% end
% 
% 
% 
% 


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
