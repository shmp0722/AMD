%% テキスト ファイルからデータをインポートします。
% 次のテキスト ファイルからデータをインポートするスクリプト:
%
%    /home/ganka/git/AMD/DiffusionMeasure/OphthalmicParameter/AMD_VA.csv
%
% コードを異なる選択データやテキスト ファイルに拡張するには、スクリプトではなく関数を生成します。

% MATLAB による自動生成 2016/09/26 23:07:45

%% 変数を初期化します。
filename = '/home/ganka/git/AMD/DiffusionMeasure/OphthalmicParameter/AMD_VA.csv';
delimiter = ',';
startRow = 2;

%% データの列を文字列として読み取る:
% 詳細は TEXTSCAN のドキュメンテーションを参照してください。
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% テキスト ファイルを開きます。
fileID = fopen(filename,'r');

%% データの列を書式文字列に従って読み取ります。
% この呼び出しは、このコードの生成に使用されたファイルの構造に基づいています。別のファイルでエラーが発生する場合は、インポート
% ツールからコードの再生成を試みてください。
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% テキスト ファイルを閉じます。
fclose(fileID);

%% 数値文字列を含む列の内容を数値に変換します。
% 非数値文字列を NaN で置き換えます。
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[2,3,4,5,6,7,8,9,10,11]
    % 入力セル配列の文字列を数値に変換します。非数値文字列が NaN で置き換えられました。
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % 数値でない接頭辞と接尾辞を検出して削除する正規表現を作成します。
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % 桁区切り以外の場所でコンマが検出されました。
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % 数値文字列を数値に変換します。
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end


%% データを数値列とセル列に分割します。
rawNumericColumns = raw(:, [2,3,4,5,6,7,8,9,10,11]);
rawCellColumns = raw(:, 1);


%% インポートした配列を列変数名に割り当てます
VarName1 = rawCellColumns(:, 1);
rightVA = cell2mat(rawNumericColumns(:, 1));
leftVA = cell2mat(rawNumericColumns(:, 2));
rightlogMAR = cell2mat(rawNumericColumns(:, 3));
leftlogMAR = cell2mat(rawNumericColumns(:, 4));
right = cell2mat(rawNumericColumns(:, 5));
left = cell2mat(rawNumericColumns(:, 6));
logMARVARL = cell2mat(rawNumericColumns(:, 7));
AveMT = cell2mat(rawNumericColumns(:, 8));
AveMT222JPN_Ave = cell2mat(rawNumericColumns(:, 9));
AbsAveMTJPNAve = cell2mat(rawNumericColumns(:, 10));


%% 一時変数のクリア
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns;