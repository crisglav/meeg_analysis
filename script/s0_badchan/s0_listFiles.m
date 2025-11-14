% Script that lists all the raw MEG files in project/data/raw/ and prepares
% metadata in project/meta/bad

clc
clear
close all

% Adds the functions folders to the path.
addpath( fullfile ( fileparts (pwd), 'functions' ) );
addpath( fullfile ( fileparts (pwd), 'mne_silent' ) );

% Read config from json file
config = load_config( fullfile('..','..','config_s0.json') );

% Sets the paths
config.path.raw  = fullfile ( config.path.project_root, 'data' , 'raw' );
config.path.meta = fullfile ( config.path.project_root, 'meta', 'bad' );
config.path.patt = '*.fif';

% Action when the task has already been processed.
config.overwrite = false;

% Adds, if needed, the FieldTrip folder to the path.
myft_path ( config.path.ft_path ) 

% Creates the output folder, if required.
if ~exist ( config.path.meta, 'dir' ), mkdir ( config.path.meta ); end

% Makes a deep look for files.
files = dir( fullfile( config.path.raw,config.path.patt ) );
% files  = my_deepfind ( config.path.raw, config.path.patt );

% Goes through each file.
for findex = 1: numel ( files )

    % Extract filename
    [ ~, filename ]  = fileparts ( files ( findex ).name );
    
    % (Nebre) Checks if the file already exists.
    if exist ( fullfile( config.path.meta, [ filename , '.mat'] ) , 'file' ) && ~config.overwrite
        warning ( 'Ignoring %s (already extracted).', files ( findex ).name )
        continue
    end
    
    fprintf ( 1, 'Reading metadata from %s.\n', files ( findex ).name );
    
    % Defines the dataset.
    file   = fullfile( files ( findex ).folder, files ( findex ).name );
    
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
    save ( '-v6', fullfile ( config.path.meta, filename ) , '-struct', 'meta' )
end
