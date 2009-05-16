%% build the gaimc distribution
function buildgaimc(varargin)
if ~isempty(strmatch('all',varargin))
    buildlist = {'test','pages','zip'};
else
    buildlist = varargin;
end    
tobuild = @(type,buidlist) ~isempty(strmatch(type,buildlist));
gaimcversion = '1.0';
mypath = fileparts(mfilename('fullpath'));
oldpath = pwd;
matlablpath=path;
try
    if tobuild('test',buildlist)
        fprintf('Running tests...\n\n');
        cd(mypath)      % move to where we think we are
        cd ../          % in main gaimc directory
        addpath(pwd);   % add it to the path
        cd test         % run tests
        try
            test_main
        catch ME
            fprintf('*************\n')
            fprintf('Tests failed!\n');
            fprintf('*************\n')
            fprintf('\n');
            fprintf('Build halted.\n');
            fprintf('\n');
            fprintf('Test error:\n');
            rethrow(ME);
        end
	end
    
    if tobuild('pages',buildlist)
        fprintf('Building demos...\n\n');
        cd(mypath)      % move to where we think we are
        cd ../          % in main gaimc directory
        addpath(pwd);   % add it to the path
        cd demo
        try
            publish('demo');
            publish('airports');
            publish('performance_comparison_simple');
            if tobuild('pages_fullperf')
                publish('performance_comparison');
            end
        catch ME
            fprintf('******************\n')
            fprintf('Publishing failed!\n');
            fprintf('******************\n')
            fprintf('\n');
            fprintf('Build halted.\n');
            fprintf('\n');
            fprintf('Test error:\n');
            rethrow(ME);
        end
    end
    
    if tobuild('zip',buildlist)
        cd(mypath)      % move to where we think we are
        try
            cd ../../
            [status,result] = system(...
                sprintf('zip -r gaimc/build/gaimc-%s.zip gaimc/*.m gaimc/demo gaimc/test gaimc/graphs',...
                gaimcversion));
            result
        catch ME
            fprintf('******************\n')
            fprintf('Zipping failed!\n');
            fprintf('******************\n')
            fprintf('\n');
            fprintf('Build halted.\n');
            fprintf('\n');
            fprintf('Error:\n');
            rethrow(ME);
        end
    end        
        
catch ME
    cd(oldpath); % move to where we think we are
    path(matlabpath);
    rethrow(ME)
end

cd(oldpath); 
path(matlabpath);
    
