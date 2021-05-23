path1='/DATA/Sanjay/CFOSI/TUM_GAID/Depth_Cropped_Fliped_Renamed_BinaryImageShifted_Fliped_CFOSI_PEI/';
list1 = dir(path1);
fName1 = {list1.name};
[~,y1]=size(fName1);
path
tic;

train = [];
for f_no=3:32
    list2 = dir(char(strcat(path1,fName1(f_no),'/')));
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=9:y2
        list3 = dir(char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/')));
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        path2 = char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/'));
        %         labels1 = [labels1, (f_no-2)];
        %         lenghtOfPose = [lenghtOfPose, (y3-2)];
        for fff_no=3:y3
            path3 = char(strcat(path2,fName3(fff_no)));
            image = double(imread(path3));
            max1 = max(image(:));
            image = image/max1;
            temp=image(:);
            train=[train; double(temp')];
            %             count = count+1;
        end
    end
end


[coeff,score,~,~,explained] = pca(train);
sm = 0;
no_components = 0;
for k = 1:size(explained,1)
    sm = sm+explained(k);
    if sm <= 99.4029
        no_components= no_components+1;
    end
end
m = mean(train,1);
mat1 = score(:,1:no_components);
size(train)
size(mat1)

labels1 = [];
lenghtOfPose = [];
train = [];
count = 0;
for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'/')));
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=9:y2
        list3 = dir(char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/')));
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        path2 = char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/'));
        labels1 = [labels1, (f_no-2)];
        lenghtOfPose = [lenghtOfPose, (y3-2)];
        for fff_no=3:y3
            path3 = char(strcat(path2,fName3(fff_no)));
            image = double(imread(path3));
            max1 = max(image(:));
            Image = image/max1;
            Img_mean = double(Image(:)')-m;
            Img_proj = Img_mean*coeff;
            train_features = Img_proj(:,1:no_components);
            train=[train;  train_features];
            count = count+1;
        end
    end
end

tr = size(train)
lb = size(labels1)

% train = [];
labels2 = [];
labels3 = [];
for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'/')));
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=3:4
        list3 = dir(char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/')));
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        path2 = char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/'));
        labels2 = [labels2, (f_no-2)];
        test = [];
        for fff_no=3:y3
            path3 = char(strcat(path2,fName3(fff_no)));
            image = double(imread(path3));
            max1 = max(image(:));
            Image = image/max1;
            Img_mean = double(Image(:)')-m;
            Img_proj = Img_mean*coeff;
            test_features = Img_proj(:,1:no_components);
            test = [test; test_features];
        end
        %         size(test)
        count1=1;
        distAcc = [];
        train1 = train;
        lenghtOfPose1 = lenghtOfPose;
        lb3 = [];
        
        for number1=1:length(labels1)
            x = train1(count1:(count1+lenghtOfPose1(number1)-1),:);
            dist = dtw(x',test');
            distAcc = [distAcc,dist];
            count1 = count1+lenghtOfPose1(number1);
        end
        [min1,index] = min(distAcc);
        labels11 = labels1;
        lb = labels1(index);
        lb3 = [lb3,lb];
        subjects = find(labels1==lb);
        labels11(subjects)=[];
        distAcc(subjects)=[];
        for num11=1:19
            [min1,index] = min(distAcc);
            lb = labels11(index);
            lb3 = [lb3,lb];
            subjects = find(labels11==lb);
            labels11(subjects)=[];
            distAcc(subjects)=[];
        end
        labels3 = [labels3; lb3];
        %end
    end
end

path = '/DATA/Sanjay/CFOSI/TUM_GAID/TUM_GAID_DTW/';
csvwrite(char(strcat(path,'CASIA_labels2_bg2nm.csv')),labels2);
csvwrite(char(strcat(path,'CASIA_labels3_bg2nm.csv')),labels3);
rankedAccu =[];
for num11=1:20
    count=0;
    for number1=1:length(labels2)
        arr = labels3(number1,1:num11)==labels2(number1);
        if nonzeros(arr)>0
            count = count+1;
        end
    end
    accu1 = (count/length(labels2))*100;
    rankedAccu = [rankedAccu,accu1];
end
disp("bg to nm")
rankedAccu
csvwrite(char(strcat(path,'CASIA_labels3_bg2nm_rankedAccu.csv')),rankedAccu);


labels2 = [];
labels3 = [];
for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'/')));
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=5:6
        list3 = dir(char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/')));
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        path2 = char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/'));
        labels2 = [labels2, (f_no-2)];
        test = [];
        for fff_no=3:y3
            path3 = char(strcat(path2,fName3(fff_no)));
            image = double(imread(path3));
            max1 = max(image(:));
            Image = image/max1;
            Img_mean = double(Image(:)')-m;
            Img_proj = Img_mean*coeff;
            test_features = Img_proj(:,1:no_components);
            test = [test; test_features];
        end
        %         size(test)
        count1=1;
        distAcc = [];
        train1 = train;
        lenghtOfPose1 = lenghtOfPose;
        lb3 = [];
        
        for number1=1:length(labels1)
            x = train1(count1:(count1+lenghtOfPose1(number1)-1),:);
            dist = dtw(x',test');
            distAcc = [distAcc,dist];
            count1 = count1+lenghtOfPose1(number1);
        end
        [min1,index] = min(distAcc);
        labels11 = labels1;
        lb = labels1(index);
        lb3 = [lb3,lb];
        subjects = find(labels1==lb);
        labels11(subjects)=[];
        distAcc(subjects)=[];
        for num11=1:19
            [min1,index] = min(distAcc);
            lb = labels11(index);
            lb3 = [lb3,lb];
            subjects = find(labels11==lb);
            labels11(subjects)=[];
            distAcc(subjects)=[];
        end
        labels3 = [labels3; lb3];
        %end
    end
end

path = '/DATA/Sanjay/CFOSI/TUM_GAID/TUM_GAID_DTW/';
csvwrite(char(strcat(path,'CASIA_labels2_cl2nm.csv')),labels2);
csvwrite(char(strcat(path,'CASIA_labels3_cl2nm.csv')),labels3);
rankedAccu =[];
for num11=1:20
    count=0;
    for number1=1:length(labels2)
        arr = labels3(number1,1:num11)==labels2(number1);
        if nonzeros(arr)>0
            count = count+1;
        end
    end
    accu1 = (count/length(labels2))*100;
    rankedAccu = [rankedAccu,accu1];
end
disp("cl to nm")
rankedAccu
csvwrite(char(strcat(path,'CASIA_labels3_cl2nm_rankedAccu.csv')),rankedAccu);


labels2 = [];
labels3 = [];
for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'/')));
    fName2 = {list2.name};
    [~,y2]=size(fName2);
    fName1(f_no)
    for ff_no=7:8
        list3 = dir(char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/')));
        fName3 = {list3.name};
        [~,y3]=size(fName3);
        path2 = char(strcat(path1,fName1(f_no),'/',fName2(ff_no),'/'));
        labels2 = [labels2, (f_no-2)];
        test = [];
        for fff_no=3:y3
            path3 = char(strcat(path2,fName3(fff_no)));
            image = double(imread(path3));
            max1 = max(image(:));
            Image = image/max1;
            Img_mean = double(Image(:)')-m;
            Img_proj = Img_mean*coeff;
            test_features = Img_proj(:,1:no_components);
            test = [test; test_features];
        end
        %         size(test)
        count1=1;
        distAcc = [];
        train1 = train;
        lenghtOfPose1 = lenghtOfPose;
        lb3 = [];
        
        for number1=1:length(labels1)
            x = train1(count1:(count1+lenghtOfPose1(number1)-1),:);
            dist = dtw(x',test');
            distAcc = [distAcc,dist];
            count1 = count1+lenghtOfPose1(number1);
        end
        [min1,index] = min(distAcc);
        labels11 = labels1;
        lb = labels1(index);
        lb3 = [lb3,lb];
        subjects = find(labels1==lb);
        labels11(subjects)=[];
        distAcc(subjects)=[];
        for num11=1:19
            [min1,index] = min(distAcc);
            lb = labels11(index);
            lb3 = [lb3,lb];
            subjects = find(labels11==lb);
            labels11(subjects)=[];
            distAcc(subjects)=[];
        end
        labels3 = [labels3; lb3];
        %end
    end
end

path = '/DATA/Sanjay/CFOSI/TUM_GAID/TUM_GAID_DTW/';
csvwrite(char(strcat(path,'CASIA_labels2_fs2nm.csv')),labels2);
csvwrite(char(strcat(path,'CASIA_labels3_fs2nm.csv')),labels3);
rankedAccu =[];
for num11=1:20
    count=0;
    for number1=1:length(labels2)
        arr = labels3(number1,1:num11)==labels2(number1);
        if nonzeros(arr)>0
            count = count+1;
        end
    end
    accu1 = (count/length(labels2))*100;
    rankedAccu = [rankedAccu,accu1];
end
disp("nm to nm")
rankedAccu
csvwrite(char(strcat(path,'CASIA_labels3_nm2nm_rankedAccu.csv')),rankedAccu);

toc;