% Script that lists all the raw MEG files in project/data/raw/ and prepares
% metadata in project/meta/bad

clc
clear
close all

% Sets the paths.
% config.path.project_root = '/home/cgil/megtusalen_data';
config.path.project_root = 'C:\Users\Cristina\megtusalen-mini\';
config.path.raw  = fullfile(config.path.project_root, 'data' ,'raw');
config.path.meta = fullfile(config.path.project_root, 'meta', 'bad');
config.path.patt = '*.fif';

% Action when the task has already been processed.
config.overwrite = false;

% Adds the functions folders to the path.
addpath ( sprintf ( '%s/functions/', fileparts ( pwd ) ) );
addpath ( sprintf ( '%s/mne_silent/', fileparts ( pwd ) ) );

% Adds, if needed, the FieldTrip folder to the path.
<<<<<<< HEAD
myft_path ( 'C:\Users\Cristina\repos\fieldtrip\' ) 
=======
addpath ( '/home/cgil/repos/fieldtrip-20200130')
myft_path
>>>>>>> 739164484d7069b961b580c70cb801089bdad65e

% Creates the output folder, if required.
if ~exist ( config.path.meta, 'dir' ), mkdir ( config.path.meta ); end

% Makes a deep look for files.
files  = my_deepfind ( config.path.raw, config.path.patt );

% Goes through each file.
for findex = 1: numel ( files )
    
    % (Nebre) Checks if the file already exists.
    if exist ( sprintf ( '%s%s.mat', config.path.meta, files ( findex ).name ), 'file' )&&~config.overwrite
        warning ( 'Ignoring %s (already extracted).', files ( findex ).name )
        continue
    end
    
    fprintf ( 1, 'Reading metadata from %s.\n', files ( findex ).name );
    
    % Defines the dataset.
    file   = sprintf ( '%s%s', files ( findex ).folder, files ( findex ).name );
    
    % Gets the file metadata.
    header = my_read_header ( file );
    event  = my_read_event  ( file, header );
    
    % Prepares the output.
    meta        = [];
    meta.file   = file;
    meta.header = header;
    meta.event  = event;
    meta.bad    = [];
    
    % Saves the data.
    save ( '-v6', sprintf ( '%s%s.mat', config.path.meta, files ( findex ).name ), '-struct', 'meta' )
end
