function [y_bg,y_corr,xGrid,yGrid]=Volt_spline_2(ex,ey,bounds)

nTraces = size(ey,2);
% create linspace with boundaries for polyfit
% nTraces is for the forward, reverse, and/or difference

for k = 1:nTraces
    
    if size(bounds,2)==2
        a_down(k,:)=linspace(min(ex(:,k)),bounds(k,1),7);
        a_up(k,:)=linspace(bounds(k,2),max(ex(:,k)),7);
        bounds_fill(k,:)=[a_down(k,:) a_up(k,:)];
    elseif size(bounds,2)==4 & bounds(k,2)~= bounds(k,3) & bounds(k,1)~= bounds(k,3);
        a_down(k,:)=linspace(min(ex(:,k)),bounds(k,1),5);
        a_mid(k,:)=linspace(bounds(k,2),bounds(k,3),2);
        a_up(k,:)=linspace(bounds(k,4),max(ex(:,k)),5);
        bounds_fill(k,:)=[a_down(k,:) a_mid(k,:) a_up(k,:)];
    elseif size(bounds,2)==4 & bounds(k,2)== bounds(k,3) & bounds(k,1)~= bounds(k,3);
        a_down(k,:)=linspace(min(ex(:,k)),bounds(k,1),5);
        a_mid(k,:)=bounds(k,2);
        a_up(k,:)=linspace(bounds(k,4),max(ex(:,k)),5);
        bounds_fill(k,:)=[a_down(k,:) a_mid(k,:) a_up(k,:)];
    elseif size(bounds,2)==4 & bounds(k,1)==bounds(k,3) & bounds(k,2)== bounds(k,4);
        a_down(k,:)=linspace(min(ex(:,k)),bounds(k,1),7);
        a_up(k,:)=linspace(bounds(k,4),max(ex(:,k)),7);
        bounds_fill(k,:)=[a_down(k,:) a_up(k,:)];
    %elseif 
     %   error('Rows of bounds values must take one of the forms \n[a b] \n[a b c d] \n[a b b c] \n[a b a b]');
    end    
    xGrid(:,k) = bounds_fill(k,:).';
end

 for k = 1:nTraces
     yGrid(:,k)=interp1(ex(:,k),ey(:,k),xGrid(:,k));
    % interpolate spline back onto x axis for data
     y_bg(:,k)=interp1(xGrid(:,k),yGrid(:,k),ex(:,k),'spline');
    % subtract the spline
     y_corr(:,k) = ey(:,k) - y_bg(:,k);
 end


subplot(1,2,1);
hold on
plot(ex,ey,ex,y_bg,'k-');
plot(xGrid,yGrid,'o');
%legend('for','rev','diff');
xlim([min(ex(:,1)) max(ex(:,1))]);
subplot(1,2,2);
hold on
plot(ex,y_corr,'k-');
xlim([min(ex(:,1)) max(ex(:,1))]);

end
