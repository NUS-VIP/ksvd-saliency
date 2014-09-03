function parseMitData()
datasetName = 'mit';
globals;

users = {'CNG', 'ajs', 'emb', 'ems', 'ff', 'hp', 'jcw', 'jw', 'kae', 'krl', 'po', 'tmj', 'tu', 'ya', 'zb'};

fixations = cell(STIMULI_NUM, 1);
for i = 1 : STIMULI_NUM
    filename = STIMULI_FILES(i).name;
    img = imread(fullfile(PATH_STIMULI, filename));
    [h, w, c] = size(img);
    
	fixations{i}.img = filename;
	fixations{i}.subjects = cell(length(users), 1);

    allFix=[];
    for j = 1:length(users)
        user = users{j};
        
        datafolder = [PATH_RAW_DATA, '/', user];
        datafile = strcat(filename(1:end-length(IMG_EXT)), 'mat');
        load(fullfile(datafolder, datafile));
        
        stimFile = eval([datafile(1:end-length(IMG_EXT)-1)]);
        eyeData = stimFile.DATA(1).eyeData;
        [eyeData Fix Sac] = checkFixations(eyeData);

        fixs = Fix.medianXY(2:end, :);
        fix_duration = Fix.duration(2:end);
        
        indices = find(fixs(:,1)>0 & fixs(:,1)<=w & fixs(:,2)>0 & fixs(:,2) <= h);
        fixs = fixs(indices,:);
        fix_duration = fix_duration(indices);
       
        fixations{i}.subjects{j}.fix_x = fixs(:, 1)';
        fixations{i}.subjects{j}.fix_y = fixs(:, 2)';
        fixations{i}.subjects{j}.fix_duration = fix_duration;
    end
    
end

save(FILE_FIXATIONS, 'fixations');