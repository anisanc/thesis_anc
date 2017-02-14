function varargout = logging_eval(varargin)
% Last Modified by GUIDE v2.5 01-May-2016 19:43:43
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @logging_eval_OpeningFcn, ...
                   'gui_OutputFcn',  @logging_eval_OutputFcn, ...
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

function logging_eval_OpeningFcn(hObject, eventdata, handles, varargin)
handles.data1 = importdata('w15_5_7.mat');
handles.data2 = importdata('w15_6_11s.mat');
handles.data3 = importdata('w15_6_9s.mat');
handles.data4 = importdata('w16_2_7.mat');
handles.data5 = importdata('w16_7_9.mat');
well_name = {handles.data1.wellid, handles.data2.wellid,handles.data3.wellid,...
    handles.data4.wellid, handles.data5.wellid};
set(handles.popupmenu1, 'String',well_name);
set([handles.popupmenu2,handles.popupmenu3,handles.popupmenu4],...
    'String',{'Gamma Ray','Sonic','Density','Neutron','Resistivity'});

addpath 'Data_Log\Casing'
addpath 'Data_Log\Formation'

[~,~,handles.data1.formation]=xlsread('data 15_5_7.xlsx');
[~,~,handles.data2.formation]=xlsread('data 15_6_11s.xlsx');
[~,~,handles.data3.formation]=xlsread('data 15_6_9s.xlsx');
[~,~,handles.data4.formation]=xlsread('data 16_2_7.xlsx');
[~,~,handles.data5.formation]=xlsread('data 16_7_9.xlsx');

[~,~,handles.data1.casing]=xlsread('15_5_7.xlsx');
[~,~,handles.data2.casing]=xlsread('15_6_11s.xlsx');
[~,~,handles.data3.casing]=xlsread('15_6_9s.xlsx');
[~,~,handles.data4.casing]=xlsread('16_2_7.xlsx');
[~,~,handles.data5.casing]=xlsread('16_7_9.xlsx');
handles.n=1;

handles.output = hObject;
guidata(hObject, handles);

function varargout = logging_eval_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
well_number = get(handles.popupmenu1,'Value');
type        = get(handles.popupmenu2,'Value');

data = data_screen(well_number,type,handles);
h1 = figure(handles.n);
h2 = figure(handles.n+1);
handles.n = handles.n+2;
radio_button = get(handles.uibuttongroup1,'SelectedObject');
value        = radio_button.ListboxTop;

if value == 1
    plot_no_group(data.all,h1,h2,data.name,data.unit,data.min_limit,data.max_limit);
else if value==2
        plot_result_litho(data.all,h1,h2,data.name,data.unit,data.min_limit,data.max_limit);
    else if value==3
            plot_result_litho_and_hole(data.all,h1,h2,data.name,data.unit,data.min_limit,data.max_limit);
        end
    end
end
handles.output = hObject;
guidata(hObject, handles);

 
function [data] = data_screen(well_number, type_log, handles)
well        = eval(strcat('handles.data',num2str(well_number)));
log_data    = well.curves;
name        = well.curve_info;
casing      = well.casing;
formation   = well.formation;

if type_log==1
    x  = find_data(name,log_data,{'GR'});
    data.max_limit = 250;
    data.min_limit = 0;
    data.unit      ='Gamma Ray (GAPI)';    
else if type_log==2
        x  = find_data(name,log_data,{'AC'});
        data.max_limit = 200;
        data.min_limit = 40;
        data.unit        ='Sonic (delta T)';
    else if type_log==3
            x  = find_data(name,log_data,{'DEN'});
            data.max_limit = 2.95;
            data.min_limit = 1.5;
            data.unit        ='Density (g/cc)';
        else if type_log ==4
                x  = find_data(name,log_data,{'NEU'});
                data.max_limit = 0.65;
                data.min_limit = -0.15;
                data.unit        ='Neutron';
            else if type_log == 5
                x  = find_data(name,log_data,{'RDEP'});
                x = log10(x);
                data.max_limit = 2;
                data.min_limit = -1;
                data.unit        ='Resistivity';
                end
            end
        end
        
    end
end

depth = log_data(:,1);
casing(1:2,:)=[];
formation(1,:)=[];

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
    if i==1 & a~=1
        a=1;
    end
    tmp(:,1)=depth(a:b)';
    tmp(:,2)=x(a:b)';

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
    if i==1 & a~=1
        a=1;
    end
    hole_size(a:b)=casing(i,1);
    top = bottom;
end
if b<length(depth)
    hole_size(b+1:length(depth))=casing(i,1);
end
 hole_size=hole_size';
 data.all=[num2cell(depth),num2cell(x),hole_size,formation_name,litho_name];
 data.name = name;


function x = find_data(name, data, data_name)
for i=1:length(data_name);
    curve_pos = find(strcmp(data_name{i},name(:,3)));
    if strcmp(data_name{i},'AC')==1 & isempty(curve_pos)==1
        curve_pos = find(strcmp('DTC',name(:,3)));
    end
    x(:,i) = data(:,curve_pos);   
end

function [] = plot_no_group(data,figure1,figure2,well_name,unit,minimum, maximum)
figure(figure1)
boxplot(cell2mat(data(:,2)));
ylabel(unit,'Fontsize',20);
set(gca,'fontsize',20,'YLim',[minimum maximum]);

figure(figure2)
histogram(cell2mat(data(:,2)),'binmethod','scott','normalization','pdf');
xlabel(unit,'FontSize',18);
ylabel('Density','Fontsize',18);
set(gca,'fontsize',18,'XLim',[minimum maximum]);

function []= plot_result_litho_and_hole(data,figure1,figure2,well_name,unit,minimum,maximum)
[hole_size,~,~] = unique(data(:,3),'stable');
[lithology,~,~] = unique(data(:,5),'stable');
n=1;
m=1;

for i=1:length(lithology)
    data_filter=data((strcmp(data(:,5),lithology(i))==1),1:5);
    if isempty(data_filter)==0
        figure(figure1)
        subplot (1,length(lithology),n);
        boxplot(cell2mat(data_filter(:,2)),char(data_filter(:,3)));
        title(strcat(lithology(i)),'FontSize',16);
        ylabel(unit,'Fontsize',16);  xlabel('Hole Size','Fontsize',16);
        set(gca,'fontsize',16,'YLim',[minimum maximum]);

        hold on
    end
    for j=1:length(hole_size)
        data_filter_2=data_filter((strcmp(data_filter(:,3),hole_size(j))==1),1:5);
        if isempty(data_filter_2)==0          
            figure(figure2)
            subplot (length(lithology),length(hole_size),m);
            histogram(cell2mat(data_filter_2(:,2)),'binmethod','scott','normalization','pdf');
            title(strcat(hole_size(j),' ',lithology(i)));
            xlabel(unit,'Fontsize',8);  ylabel('Density','Fontsize',8);
            set(gca,'XLim',[minimum maximum],'fontsize',10);
            hold on
        end
        m=m+1;
    end
    n=n+1;
end
figure(figure1)
ax1=axes('Units','Normalized','Position',[.075 .1 .85 .85],'Visible','off');
set(get(ax1,'Title'),'Visible','on');
title(well_name,'Fontsize',20);

figure(figure2)
ax2=axes('Units','Normalized','Position',[.075 .1 .85 .85],'Visible','off');
set(get(ax2,'Title'),'Visible','on');
title(well_name,'Fontsize',18);

function []= plot_result_litho(data,figure1,figure2,well_name,unit,minimum,maximum)
[lithology,~,~] = unique(data(:,5),'stable');
n=1;

figure(figure1)
boxplot(cell2mat(data(:,2)),char(data(:,5)));
ylabel(unit,'Fontsize',20);
set(gca,'fontsize',20,'YLim',[minimum maximum]);

for i=1:length(lithology)
    data_filter=data((strcmp(data(:,5),lithology(i))==1),1:5);
      if isempty(data_filter)==0
       figure(figure2)
       subplot (1,length(lithology),n);
       histogram(cell2mat(data_filter(:,2)),'binmethod','scott','normalization','pdf');
       xlabel(strcat(lithology(i),unit),'FontSize',18);
       ylabel('Density','Fontsize',18);
       set(gca,'fontsize',18,'XLim',[minimum maximum]);
       hold on
       n=n+1;       
      end
end
figure(figure1)
ax1=axes('Units','Normalized','Position',[.075 .075 .85 .85],'Visible','off');
set(get(ax1,'Title'),'Visible','on');
title(well_name,'Fontsize',20);

figure(figure2)
ax2=axes('Units','Normalized','Position',[.075 .075 .85 .85],'Visible','off');
set(get(ax2,'Title'),'Visible','on');
title(well_name,'Fontsize',18);

function pushbutton2_Callback(hObject, eventdata, handles)
well = handles.popupmenu1.Value;
var1 = handles.popupmenu3.Value;
var2 = handles.popupmenu4.Value;

data_var1 = data_screen(well,var1,handles);
data_var2 = data_screen(well,var2,handles);
[hole_size,~,~] = unique(data_var1.all(:,3),'stable');

color_order =[ 0 0.502 0 ; 1 0.4 0 ; 0.502 0 0.502 ; 0.502 0.502 0.502];
lithology   ={'Shale','Sandstone','Chalk','Carbonate'};
figure(handles.n)

for i=1:length(hole_size)
    figure(handles.n)
    clf;
    ax1 = axes; set(ax1,'Position',[0.3 0.3 0.6 0.6],'NextPlot','add','Xlim',...
        [data_var1.min_limit, data_var1.max_limit],...
        'YLim',[data_var2.min_limit, data_var2.max_limit],'fontsize',8,...
        'Xaxislocation','Top','YAxislocation','Right','Box','on');
    xlabel(ax1,data_var1.unit,'fontsize',8); ylabel(ax1,data_var2.unit,'fontsize',8);
    
    ax2=axes; set(ax2,'Position',[0.3 0.1 0.6 0.15],'NextPlot','add',...
        'XLim',[data_var1.min_limit, data_var1.max_limit],'fontsize',8,'Box','on');
    xlabel(ax2,data_var1.unit,'fontsize',8);
    
    ax3=axes; set(ax3,'Position',[0.1 0.3 0.15 0.6],'NextPlot','add',...
        'YLim',[data_var2.min_limit, data_var2.max_limit],'fontsize',8,'Box','on');
    xlabel(ax3,{'Probability',' Density'},'fontsize',8); ylabel(ax3,data_var2.unit,'fontsize',8);
    
    linkaxes([ax1,ax3],'y'); linkaxes([ax1,ax2],'x');
    
    screen1_hole = data_var1.all(strcmp(data_var1.all(:,3),hole_size{i})==1,1:5);
    screen2_hole = data_var2.all(strcmp(data_var2.all(:,3),hole_size{i})==1,1:5);
    
    % Check whether the data just contain NaN or not, if yes then the
    % function will be returned.
    data_x1 = screen1_hole(:,2); data_x2 = screen2_hole(:,2);
    data_x1(cellfun(@isnan,data_x1))= {[]};
    data_x2(cellfun(@isnan,data_x2))= {[]};
    if isempty(cell2mat(data_x1))==1 | isempty(cell2mat(data_x2))==1
        continue
    end
    
    for j=1:length(lithology)
        screen1_litho = screen1_hole(strcmp(screen1_hole(:,5),lithology{j})==1,2);
        screen2_litho = screen2_hole(strcmp(screen2_hole(:,5),lithology{j})==1,2);
        % Get the log data
        dat1 = cell2mat(screen1_litho);
        dat2 = cell2mat(screen2_litho);
        % Convert NaN to empty cells
        screen1_litho(cellfun(@isnan,screen1_litho))= {[]};
        screen2_litho(cellfun(@isnan,screen2_litho))= {[]};
        %Scatterplot
        if isempty(cell2mat(screen1_litho))==0 & isempty(cell2mat(screen2_litho))==0
            scatter(dat1,dat2,10,'MarkerFaceColor',color_order(j,:),'MarkerEdgeColor','none','Parent',ax1);
            hold on
        end
        % Kernel variable 1 (yang bawah)
        if isempty(cell2mat(screen1_litho))==0
            [f1,x1]=ksdensity(dat1,'kernel','epanechnikov','npoints',2000);
            line(x1,f1,'Color',color_order(j,:),'Parent',ax2); hold on
        end
        
        %Kernel variable 2
         if isempty(cell2mat(screen2_litho))==0
            [f2,x2]=ksdensity(dat2,'kernel','epanechnikov','npoints',2000);
            line(f2,x2,'Color',color_order(j,:),'Parent',ax3); hold on
        end
        
    end
    legend(ax1,lithology);
    ax4=axes('Units','Normalized','Position',[0.1 .075 .1 .85],'Visible','off');
    set(get(ax4,'Title'),'Visible','on');
    title(strcat('Well',{'  '},handles.popupmenu1.String{well},...
        '(',hole_size{i},')'),'Fontsize',12);
    hold off
    
    handles.n = handles.n + 1;
end

handles.output = hObject;
guidata(hObject, handles);
