clc
load data.mat

%decode sound to morse

	%your code goes here!!!
    
    %Plot of the audio signal
    
    [y,fs] = audioread('morseCode4.wav');
    plot(y);
    title('Sampled data from Morse Code Wave File');
    xlabel('Sample Number');
    ylabel('Amplitude');

    % Pentru testare
   %{
   textFileName = 'output_values.txt';
   fileID = fopen(textFileName, 'w');
   fprintf(fileID, '%f\n', y);
   fclose(fileID);
 %}
    
    mCode = '';
    mCode = extractMorse(y,fs);

    
%decode morse to text (do not change this part!!!)
%mCode = '-.. ... .--. .-.. .- -... ... ';
deco = [];
mCode = [mCode ' '];	%mCode is an array containing the morse characters to be decoded to text
lCode = [];

for j=1:length(mCode)
    if(strcmp(mCode(j),' ') || strcmp(mCode(j),'/'))
        for i=double('a'):double('z')
            letter = getfield(morse,char(i));
            if strcmp(lCode, letter)
                deco = [deco char(i)];
            end
        end
        for i=0:9
            numb = getfield(morse,['nr',num2str(i)]);
            if strcmp(lCode, numb)
                deco = [deco, num2str(i)];
            end
        end
        lCode = [];
    else
        lCode = [lCode mCode(j)];
    end
    if strcmp(mCode(j),'/')
        deco = [deco ' '];
    end
end

fprintf('Decode : %s \n', deco);

function mCode = extractMorse(y,fs)
    
    % CODEX CU WPM = 10
    mCode = '';
    
    % Durata fiecarui simbol in secunde
    dot= 0.1;
    dash = 0.3;
    space_simbol = 0.1;
    space_litere = 0.3;
    space_cuv= 0.7;

    cnt_poz = 0;
    cnt_zero = 0;

    for i = 1 : length(y)
        
        if(y(i) ~= 0)
            if(cnt_zero ~= 0) % Segment NonZero
                cnt_zero = cnt_zero/fs;
                cnt_zero = round(cnt_zero,1);
                
                %This part is for test
                
                %disp('esantioane nule:');
                %disp(cnt_zero);
                
                %#####################
                
                if(cnt_zero == space_cuv)% Space cuv
                    mCode = [mCode,'/'];
                elseif (cnt_zero == space_litere) %Space litere
                    mCode = [mCode,' '];
                
                elseif (cnt_zero == space_simbol) %Sapce Simbol
                    mCode = [mCode,''];
                end
        
                cnt_zero = 0;
            end

            cnt_poz = cnt_poz + 1;
        else % Segment Zero
            if(cnt_poz ~= 0)
                cnt_poz = cnt_poz/fs;
                cnt_poz = round(cnt_poz,1);
                
                %This part is for test
                
                %disp('esantioane nenule:');
                %disp(cnt_poz);
                
                %#####################
                
                if(cnt_poz == dot)
                    mCode = [mCode,'.'];
                elseif(cnt_poz == dash)
                    mCode = [mCode,'-'];
                end

                cnt_poz = 0;
            end
            cnt_zero = cnt_zero + 1;
        end

    end

    disp(mCode);

end