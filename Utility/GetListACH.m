function List = GetListACH(ACH)
%
%
% Get subjects list involved ACH structure 
%
%
%

%%
if notDefined('ACH')
sprintf('enter ACH structure')
end


%%
for n = 1 : length(ACH)
    if  isstruct(ACH{n,1})
        List{n} =  ACH{n,1}.subjectName;
    else
        List{n}= [];
    end
end

