clc;
close all;
clear all;

%Acquiring Image
image=imread('blankOMR.png'); %Acquiring image(transparent also accepted)
sheet=rgb2gray(image); %Removing Hue and saturation to get only intensity from 0 to 255 (8bit)
choice='ABCD'; %Choices available

%Answers variables
recognized_ans=''; %recognized answers
correct_answers='C D B A B D B A B C D D B A C B A D C B '; %correct answers


%co-ordinate variables
x1=148; %initial x point for side 1
x2=547; %initial y point for side 1
y=360; %initial y point for side 1 & 2
spacing_x=63; %Horizontal spacing in the "circles"
spacing_y=52; %Vertical spacing in the circuits
questions_per_side=10;
total_questions=20;
no_of_choices=4;

%Left side questions
for row=1:questions_per_side                               
    current_y=y+(row-1)*spacing_y;    
       
    for column=1:no_of_choices          
    current_x=x1+(column-1)*spacing_x;
    
    if(sheet(current_y,current_x)<30)        
        marks(row,column)=0; %Setting 0 because value is below threshold
     else
        marks(row,column)=1; %Setting 1 because value is above threshold
    end
    
    end
    
end
 
%Right Side Questions
for row=((total_questions-questions_per_side)+1):questions_per_side*2                               
    current_y=y+(row-11)*spacing_y;    
       
    for column=1:no_of_choices        
    current_x=x2+(column-1)*spacing_x;
    
    if(sheet(current_y,current_x)<30)        
        marks(row,column)=0; % Setting 0 because value is below threshold (darkened spot)
     else
        marks(row,column)=1; % Setting 1 because value is above threshold (non-darkened spot)
    end
    
    end
    
end
    

% Calculating Marks from "marks" table
for row=1:(questions_per_side*2)                                             
    m=0;
    for column=1:no_of_choices                                       
    if(marks(row,column)==0)                                     
        recognized_ans=[recognized_ans ' ' choice(column)];
    else
        m=m+1;
    end
    end
    if(m==4)                                           
        recognized_ans=[recognized_ans ' BLANK'];
    end
end
score=0;
disp(['Recognized Answers : ' recognized_ans]);
disp(['Correct Answers : ' (correct_answers)]);

for row=1:total_questions
    [tkn,rmn]=strtok(recognized_ans);
    [ktoken,kremain]=strtok(correct_answers);
    if(tkn==ktoken)
        score=score+1;
    end
    recognized_ans=rmn;
    correct_answers=kremain;
end
    
 disp('Marks Obtained : ')
 disp(score);
if(score==20)
    status='PASS';
else
    status='FAIL';
end

h = msgbox(['TOTAL MARKS OBTAINED : ' num2str(score) '    ' ' RESULT : ' status], ' Score');