function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 07-Sep-2014 20:55:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Starting interface...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution has been activated
tic;
% Global variable points is stored to guidata with default value
handles.points = [];
% Time of execution is logged
log = [{strcat('Interface started in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function resolution_Callback(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resolution as text
%        str2double(get(hObject,'String')) returns contents of resolution as a double


% --- Executes during object creation, after setting all properties.
function resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calchomology.
function calchomology_Callback(hObject, eventdata, handles)
% hObject    handle to calchomology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Calculating homology ...'};log];
set( hlog,'String',log ); drawnow;
% Timer of execution is activated
tic;
% Value selected of filename and cameras_begin must be positive
object = findobj('Tag','filename');
filename = get(object,'String');
object = findobj('Tag','resolution');
resolution = str2double(get(object,'String'));
object = findobj('Tag','cameras_begin');
value = get(object,'Value');
string = get(object,'String');
cameras_begin = str2double(string(value,:));
object = findobj('Tag','cameras_end');
value = get(object,'Value');
string = get(object,'String');
cameras_end = str2double(string(value,:));
% Values cameras_begin and resolution must be possitive
if isnumeric(cameras_begin) && isnumeric(cameras_end) && isnumeric(resolution)...
    && cameras_begin>0 && cameras_end>0 && resolution>0
  if strcmp(filename,'./example1.txt')
    load( 'example1.mat','points','dimension','boundary','H','g','barcode' );
  elseif strcmp(filename,'./example2.txt')
    load( 'example2.mat','points','dimension','boundary','H','g','barcode' );
  elseif strcmp(filename,'./example3.txt')
    load( 'example3.mat','points','dimension','boundary','H','g','barcode' );
  else
    % If file exists then homology is calculated
    [ points,dimension,boundary,H,g,barcode ] = calchomology( filename,resolution,cameras_begin,cameras_end,handles.min_coord,handles.max_coord );
  end;
  % Global variables points, dimension, boundary, H and g are stored to
  % guidata
  handles.points = points;
  handles.dimension = dimension;
  handles.boundary = boundary;
  handles.H = H;
  handles.g = g;
  handles.barcode = barcode;
  listcameras=[];
  for i=cameras_begin:cameras_end
      listcameras=[listcameras;i];
  end
  object = findobj('Tag','cameras_view');
  set(object,'String',listcameras);
  set(object,'Value',size(listcameras,1));
else
  % If file doesn't exist then error mesage is diplayed
  warningMessage = sprintf('Error: Cameras and resolution must be positive.\n');
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('Homology calculated in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);
guidata(hObject, handles);


% --- Executes on button press in selectfile.
function selectfile_Callback(hObject, eventdata, handles)
% hObject    handle to selectfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Selecting file...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution is activated
tic
% A file is selected by gui
[filename,pathname] = uigetfile('*.txt','Select file...');
filename = strcat( pathname,filename );
if exist(filename, 'file')
  % If file exists then values of filename and cameras_begin are stored to
  % objects
  object = findobj('Tag','filename');
  set(object,'String',filename);
  % List of cameras_begin is obtained from archive 'filename'
  [ listcameras,handles.min_coord,handles.max_coord ] = getcameras(filename);
  object = findobj('Tag','cameras_begin');
  set(object,'String',listcameras);
  set(object,'Value',1);
  set(object,'Enable','on');
  object = findobj('Tag','cameras_end');
  set(object,'String',listcameras);
  set(object,'Value',size(listcameras,1));
  set(object,'Enable','on');
  object = findobj('Tag','cameras_view');
  set(object,'String','Select...');
  set(object,'Value',1);
  object = findobj('Tag','resolution');
  set(object,'String','0.04');
  set(object,'Enable','on');
  % Global variable points is stored to guidata with default value
  handles.points = [];
else
  % If file doesn't exist then cameras_begin is stored to object with default
  % value
  object = findobj('Tag','cameras');
  set(object,'String',{'Select...'});
  % A error message is displayed
  warningMessage = sprintf('Error: File does not exist:\n%s\n', filename);
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('File selected in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);
guidata(hObject, handles);



% --- Executes on selection change in cameras_begin.
function cameras_begin_Callback(hObject, eventdata, handles)
% hObject    handle to cameras_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns cameras_begin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameras_begin


% --- Executes during object creation, after setting all properties.
function cameras_begin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameras_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewimage.
function viewimage_Callback(hObject, eventdata, handles)
% hObject    handle to viewimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Viewing image 3D...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution is activated
tic
% Values of filename and cameras_begin are obtained
object = findobj('Tag','filename');
filename = get(object,'String');
object = findobj('Tag','cameras_view');
value = get(object,'Value');
string = get(object,'String');
cameras = str2double(string(value,:));
% Value selected of cameras_begin must be positive
if ~ischar(cameras) && ~isempty(cameras) && cameras>0
  % Image 3D is viewed
  viewimage3D(filename,cameras);
else
  % A error message is displayed
  warningMessage = sprintf('Error: Cameras must be positive.\n');
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('Image 3D viewed in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);


% --- Executes on button press in viewhomology.
function viewhomology_Callback(hObject, eventdata, handles)
% hObject    handle to viewhomology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Viewing homology...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution is activated
tic
% Value of points doesn't must be empty
if ~isempty(handles.points)
  % Global variables points, dimension, boundary, H and g are obtained
  % from guidata
  object = findobj('Tag','cameras_view');
  value = get(object,'Value');
  string = get(object,'String');
  cameras = str2double(string(value,:));
  points = handles.points{cameras};
  size(handles.dimension{cameras});
  dimension = handles.dimension{cameras};
  boundary = handles.boundary{cameras};
  H = handles.H{cameras};
  g = handles.g{cameras};
  viewhomology(points,dimension,boundary,H,g);
else
  % A error message is displayed
  warningMessage = sprintf('Error: Please, you must first calculate homology of image 3D.\n');
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('Homology viewed in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over cameras_begin.
function cameras_begin_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to cameras_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in cameras_begin.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to cameras_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cameras_begin contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameras_begin


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameras_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close();


% --- Executes during object creation, after setting all properties.
function main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on calchomology and none of its controls.
function calchomology_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to calchomology (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over calchomology.
function calchomology_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to calchomology (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in log.
function log_Callback(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from log


% --- Executes during object creation, after setting all properties.
function log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cameras_end.
function cameras_end_Callback(hObject, eventdata, handles)
% hObject    handle to cameras_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cameras_end contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameras_end


% --- Executes during object creation, after setting all properties.
function cameras_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameras_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cameras_view.
function cameras_view_Callback(hObject, eventdata, handles)
% hObject    handle to cameras_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cameras_view contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cameras_view


% --- Executes during object creation, after setting all properties.
function cameras_view_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cameras_view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewbarcode.
function viewbarcode_Callback(hObject, eventdata, handles)
% hObject    handle to viewbarcode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Viewing barcode...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution is activated
tic
% Value of points doesn't must be empty
if ~isempty(handles.points)
  % Global variables points, dimension, boundary, H and g are obtained
  % from guidata
  barcode = handles.barcode;
  viewbarcode(barcode);
else
  % A error message is displayed
  warningMessage = sprintf('Error: Please, you must first calculate homology of image 3D.\n');
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('Barcode viewed in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);


% --- Executes on button press in exportresults.
function exportresults_Callback(hObject, eventdata, handles)
% hObject    handle to exportresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Exporting results...'};log];
set( hlog,'String',log ); drawnow;
% Timer of execution is activated
tic;
% Value selected of filename and cameras_begin must be positive
object = findobj('Tag','cameras_begin');
value = get(object,'Value');
string = get(object,'String');
cameras_begin = str2double(string(value,:));
object = findobj('Tag','cameras_end');
value = get(object,'Value');
string = get(object,'String');
cameras_end = str2double(string(value,:));
% Value of points doesn't must be empty
if ~isempty(handles.points)
  % Results are exported
  exportresults( handles.points,handles.dimension,handles.H,handles.g,cameras_begin,cameras_end );
else
  % A error message is displayed
  warningMessage = sprintf('Error: Please, you must first calculate homology of image 3D.\n');
  uiwait(msgbox(warningMessage,'Error','error'));
end
% Time of execution is logged
log = [{strcat('Results exported in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);


% --- Executes when main is resized.
function main_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
points=handles.points;
dimension=handles.dimension;
boundary=handles.boundary;
H=handles.H;
g=handles.g;
barcode=handles.barcode;
save( 'example.mat','points','dimension','boundary','H','g','barcode' );


% --- Executes on button press in example.
function example_Callback(hObject, eventdata, handles)
% hObject    handle to example (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hlog is used for log's messages displayed
hlog = findobj('Tag','log');
log = get(hlog,'String');
log = [{'Selecting file...'};log];
set(hlog,'String',log); drawnow;
% Timer of execution is activated
tic
% A file is selected by gui
[filename,pathname] = uigetfile('example*.txt','Select a example file');
filename = strcat( './',filename );
if exist(filename, 'file')
  % If file exists then list of cameras_begin numbers used by voxel
  % carving has been obtained. Then, image 3D is viewed.
  objeto = findobj('Tag','filename');
  set(objeto,'String',filename);
  % List of cameras_begin is obtained from archive 'filename'
  [ listcameras,handles.min_coord,handles.max_coord ] = getcameras(filename);
  object = findobj('Tag','cameras_begin');
  set(object,'String',listcameras);
  set(object,'Value',1);
  set(object,'Enable','off');
  object = findobj('Tag','cameras_end');
  set(object,'String',listcameras);
  set(object,'Value',size(listcameras,1));
  set(object,'Enable','off');
  object = findobj('Tag','cameras_view');
  set(object,'String','Select...');
  set(object,'Value',1);
  object = findobj('Tag','resolution');
  set(object,'String','0.04');
  set(object,'Enable','off');
  cameras = listcameras(size(listcameras,1));
  viewimage3D(filename,cameras);
  % Global variable points is stored to guidata with default value
  handles.points = [];
else
  % If file doesn't exist then cameras_begin is stored to object with default
  % value
  object = findobj('Tag','cameras');
  set(object,'String',{'Select...'});
  % A error message is displayed
  warningMessage = sprintf('Error: Example file does not exist:\n%s\n', filename);
  uiwait(msgbox(warningMessage,'Error','error'));
end

% Time of execution is logged
log = [{strcat('Example loaded in ',num2str(toc),' seconds.')};log];
set(hlog,'String',log);
% Update handles structure
guidata(hObject, handles);
