%//%************************************************************************%
%//%*                  Annotation Image Quality Checker                    *%
%//%*                                                                      *%
%//%*             Author(s): Dr. Preetham Manjunatha                       *%
%//%*             Github link: https://github.com/preethamam               *%
%//%*             Submission Date: --/--/----                              *%
%//%************************************************************************%
%//%*             Viterbi School of Engineering,                           *%
%//%*             Sonny Astani Dept. of Civil Engineering,                 *%
%//%*             University of Southern california,                       *%
%//%*             Los Angeles, California.                                 *%
%//%************************************************************************%


%% Start Commands
clc; close all; clear;
clcwaitbarz = findall(0,'type','figure','tag','TMWWaitbar'); 
delete(clcwaitbarz);
tic;

%% Inputs
labeled_image_folder = "label";
original_image_folder = 'original';

imresize_values = [242,322];
resize_image = 0;  % To speed up. Use mytiledlayoutComplex = 0 without resize. Slightly faster.
mytiledlayoutComplex = 0;
showplot = 1;

%% Overlay images
img_files = dir(labeled_image_folder);
img_files = {img_files(3:end).name};

img_orifiles = dir(original_image_folder);
img_orifiles = {img_orifiles(3:end).name};

for i = 1:numel(img_files)
    
    % Image read
    Iground = logical(imread(fullfile(labeled_image_folder, img_files{i})));
    Ioriginal = imread(fullfile(original_image_folder, img_orifiles{i}));

    % Get boundaries
    bndOverlay = bwperim(Iground, 8);    

    if (resize_image == 1)
        Iground = imresize(Iground, imresize_values);
        Ioriginal = imresize(Ioriginal, imresize_values);
    end
    
    % Groundtruth to logical
    if isa(Iground,'uint8')
        Iground = imbinarize(Iground);
    end

    % Show the plot
    if showplot == 1
        fh = figure(1);
        fh.WindowState = 'maximized';

        % Get label overlay (MATLAB's inbuilt function)
        lab_overlay = labeloverlay(Ioriginal,Iground, Transparency = 0.75, Colormap = [0 1 0]);

        % Get binary mask boundries
        bndries = imoverlay(Ioriginal, bndOverlay, [0 1 0]);
        IgroundOverlay = imoverlay(Ioriginal, Iground, [0 1 0]);

        if mytiledlayoutComplex == 1
            % Show the plot        
            % Initialize a tight subplot
            tiledlayout(2,3, 'TileSpacing', 'none', 'Padding', 'compact');
    
            ax1 = nexttile; imshow(Ioriginal)
            ax2 = nexttile; imshow(IgroundOverlay)
            ax3 = nexttile; imshow(bndries) 
    
            ax4 = nexttile; imshowpair(Ioriginal,Iground, "falsecolor", ColorChannels= "green-magenta");        
            ax5 = nexttile; imshowpair(Ioriginal,Iground, "blend");               
            ax6 = nexttile; imshow(lab_overlay);

            % Link axes
            linkaxes([ax1,ax2,ax3,ax4,ax5,ax6], 'xy'); 

            % Export graphics            
            [filepath,name,ext] = fileparts(img_files{i});
            exportgraphics(gcf,fullfile('assets', [name '_complex' '.png']))
        else
            tiledlayout(1,4, 'TileSpacing', 'tight', 'Padding', 'compact');
            ax1 = nexttile; imshow(Ioriginal)
            ax2 = nexttile; imshow(IgroundOverlay)
            ax3 = nexttile; imshow(bndries);
            ax4 = nexttile; imshow(lab_overlay);

            % Link axes
            linkaxes([ax1,ax2,ax3,ax4], 'xy'); 

            % Export graphics            
            [filepath,name,ext] = fileparts(img_files{i});
            exportgraphics(gcf,fullfile('assets', [name '_focused' '.png']))
        end
        
        % Include title
        sgtitle(['Image: ' num2str(i) ' | ' 'Filename: ' img_files{i}],'Interpreter', 'none')                
        
        % Refresh figure
        drawnow

        % Press key to continue
        pause;
    end    
end

%% End Commands
clcwaitbarz = findall(0,'type','figure','tag','TMWWaitbar');
delete(clcwaitbarz);
Runtime = toc;
