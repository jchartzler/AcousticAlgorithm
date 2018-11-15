classdef PlottingClass
    % a class def file which has to be the same name as the file
   properties
      % the path to the directory
      path
      % the filename of the .mat file
      filename
      % the entire filepath
      filepath
      % the data points of the .mat
      rawdata
      % name for saving plots
      newname
      % location for the images
      imagedir
      % the range of the data to view
      Range
      % the locations of the red vertical lines
      left
      right
      % the data of the microphones
      R1
      R2
      R3
   end
   
   methods
      function lowpass = filtering(obj, s, name)
          %% the controls for the plot
          
          fs = 1000;            % sample frequency
          
          dT = 30;                %segment period in seconds
          Ov = 0.10;              %overlap in percentage of segment period
          ONseg = 0;              %1=plot every segment; 0=only plot average for each mic

          Sfilter = 1;

         if Sfilter == 1
             fcut = 200;
             order = 30;
         end
          
         h = figure;
         set(h, 'Visible', 'off');

         a=floor(obj.Range(1)*(size(s,1)-1)/(1-0)+1);
         b=ceil(obj.Range(2)*(size(s,1)-1)/(1-0)+1);
         s = s(a:b,:);
         t=(0:1/fs:size(s,1)/fs-1/fs)'; 
         
                 %% Lowpass filter (Butterworth)
        if Sfilter == 0
            sf = s;
        end
        if Sfilter == 1
            [b,a] = butter(order,fcut(1)/(fs/2),'low');
            sf = filter(b,a,s);
        end

        for mics = 1:size(s,2)
            for seg = 1:floor(size(s,1)/(dT*fs-Ov*dT*fs))
                 aa = (seg-1)*dT*fs*(1-Ov)+1; bb = aa+dT*fs-1;
                Sf =sf(aa:bb,mics);

                %% power spectrum calculation
                N = length(Sf);
                xdft = fft(Sf);
                xdft = xdft(1:N/2+1);
                psdx = (1/(fs*N)) * abs(xdft).^2;
                psdx(2:end-1) = 2*psdx(2:end-1);
                freq = 0:fs/length(Sf):fs/2;

                % save the power spectrum for each 
                if seg == 1
                    RR(:,1) = freq;
                end
                RR(:,seg+1) = psdx; 
       
            %% plot individual spectra
            if mics == 1
                mkr = '--m';
            end
            if mics == 2
                mkr = '--y';
            end
            if mics == 3
                mkr = '--c';
            end

            if ONseg == 1
                semilogx(freq,10*log10(psdx),mkr)
                %         semilogx(freq,20*log10(psdx/10^-6),mkr)
                grid on
                hold on
            end
        end
        if mics == 1
            mkr = '-b';
        end
        if mics == 2
            mkr = '-g';
        end
        if mics == 3
            mkr = '-r';
        end

        semilogx(RR(:,1),10*log10(mean(RR(:,2:size(RR,2)),2)),mkr,'LineWidth',2)
        %     semilogx(RR(:,1),20*log10(mean(RR(:,2:size(RR,2)),2)/10^-6),'-r','LineWidth',2)
        hold on
        clearvars RR
    end

    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')

    plot(obj.right, [-120,0],'--r')
    plot(obj.left, [-120,0],'--r', 'HandleVisibility','off')
    legend({'Microphone 1: Roof', 'Microphone 2: South', 'Microphone 3: North', 'Range'}, 'location', 'northwest')

    axis([.5 100 -120 0])

    type = '.png';
    tog = strcat(obj.newname, type);
    slash = '/';
    loc = strcat(obj.imagedir, 'Images', slash, tog);
    saveas(h, loc);
    close(h);
      end
        % The function will take the recoded data and plot the values
      function Plotting = Data(obj)
        time = .001:.001:1200;

        l = figure(1);
        set(l, 'Visible', 'off');

        subplot(2,2,1);
        plot(time,obj.R1, '-b')
        title('Microphone 1: Roof')
        ylim([-1 1])
        xlabel('Time (seconds)')
        ylabel('Pressure [Pa]')

        subplot(2,2,2);
        plot(time,obj.R2, '-g')
        title('Microphone 2: South')
        ylim([-1 1])
        xlabel('Time (seconds)')
        ylabel('Pressure [Pa]')

        subplot(2,2,[3,4]);
        plot(time,obj.R3, '-r')
        title('Microphone 3: North')
        ylim([-1 1])
        xlabel('Time (seconds)')
        ylabel('Pressure [Pa]')

        thisplot = 'rawdata - ';
        type = '.png';
        tog = strcat(thisplot, obj.newname, type);
        slash = '/';
        loc = strcat(obj.imagedir, 'Images', slash, tog);
        saveas(l, loc);
        close(l);

        % end the plotting function
        end
      
   end
   
end
