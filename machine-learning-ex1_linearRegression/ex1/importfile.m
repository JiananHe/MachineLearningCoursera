%% �����ı��ļ��е����ݡ�
% ���ڴ������ı��ļ��������ݵĽű�:
%
%    C:\Users\13249\Documents\����ѧϰ�μ�\machine-learning-ex1\ex1\SHIJIAZ_ALL.txt
%
% Ҫ��������չ������ѡ�����ݻ������ı��ļ��������ɺ���������ű���

% �� MATLAB �Զ������� 2018/03/21 19:16:04

%% ��ʼ��������
filename = 'C:\Users\13249\Documents\����ѧϰ�μ�\machine-learning-ex1\ex1\SHIJIAZ_ALL.txt';
delimiter = ',';
startRow = 2;

%% ����������Ϊ�ַ�����ȡ:
% �й���ϸ��Ϣ������� TEXTSCAN �ĵ���
formatSpec = '%*s%*s%*s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% ���ı��ļ���
fileID = fopen(filename,'r');

%% ���ݸ�ʽ�ַ�����ȡ�����С�
% �õ��û������ɴ˴������õ��ļ��Ľṹ����������ļ����ִ����볢��ͨ�����빤���������ɴ��롣
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% �ر��ı��ļ���
fclose(fileID);

%% ��������ֵ�ַ�����������ת��Ϊ��ֵ��
% ������ֵ�ַ����滻Ϊ NaN��
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12]
    % ������Ԫ�������е��ַ���ת��Ϊ��ֵ���ѽ�����ֵ�ַ����滻Ϊ NaN��
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % ����������ʽ�Լ�Ⲣɾ������ֵǰ׺�ͺ�׺��
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % �ڷ�ǧλλ���м�⵽���š�
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % ����ֵ�ַ���ת��Ϊ��ֵ��
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% �ų����з���ֵԪ������
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),raw),2); % ���Ҿ��з���ֵԪ������
raw(I,:) = [];

%% �����������
SHIJIAZALL = cell2mat(raw);
%% �����ʱ����
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me I J K;