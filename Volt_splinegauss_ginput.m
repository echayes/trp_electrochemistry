function [y_bg,varargout]=Volt_splinegauss_ginput(ex,ey,bounds,Gauss_max);

%generate the polynomial background
[y_bg,y_corr,xGrid,yGrid]=Volt_spline_2(ex,ey,bounds);
nTraces = size(ey,2);
% Compute step size ------------------------------------------------
step=(ex(100,1)-ex(99,1));

% find indices of the boundaries
for k = 1:nTraces
    for j=1:size(Gauss_max,2)
        Gauss_idx(k,j) = find(abs(ex(:,k)-Gauss_max(j)) < step,1);
        Imax(k,j) = y_corr(Gauss_idx(k,j),k)
    end
end

% add gaussians in for the peaks
for k = 1:nTraces    
    Vstart(k,:) = Gauss_max(k,:);        
    for j=1:size(Gauss_max,2);%depends on number of Gaussian max inputs
        FWHMstart(k,j) = 0.089;
        int(k,j) = FWHMstart(k,j).*Imax(k,j);
    end        
end


% set starting params for gaussian fit(s)
for k = 1:nTraces   
    par_start(k,:) = [Vstart(k,:) FWHMstart(k,:) int(k,:)];% a(1,:)];
end


pars_fit = fminsearch(@polygausserror1,par_start,optimset('TolX',1e-10));

    function ErrErr = polygausserror1(par_start)
        
        % create gaussians based on starting parameters
        % create new boundaries for baseline based on gaussian starting
        % parameters
        for r=1:nTraces
            if size(par_start,2)==6
            gaussfit1(:,r) = gaussian(ex(:,r),par_start(r,1),par_start(r,3))*par_start(r,5);
            gaussfit2(:,r) = gaussian(ex(:,r),par_start(r,2),par_start(r,4))*par_start(r,6);
            gaussfit(:,r) = gaussfit1(:,r) + gaussfit2(:,r);
            totalfit(:,r) = gaussfit(:,r)  + y_bg(:,r);
            elseif size(par_start,2)==3
            gaussfit(:,r)  = gaussian(ex(:,r),par_start(r,1),par_start(r,2))*par_start(r,3);
            totalfit(:,r)  = gaussfit(:,r) + y_bg(:,r);
            end            
        end
        
        for w=1:nTraces
            ErrorVector(:,w) = totalfit(:,w) - ey(:,w);
            sse(w) = real(sum(ErrorVector(:,w).^ 2));
        end
        ErrErr = real(sum(sse.^ 2));
    
    end


for k=1:size(ey,2) 
    
    if size(par_start,2)==6 %two gaussians
        parsfit(k).Volt = pars_fit(k,[1 2]); 
        parsfit(k).FWHM = pars_fit(k,[3 4]);
        parsfit(k).area = pars_fit(k,[5 6]);
        parsfit(k).Imax = [max(gaussfit1(:,k)) max(gaussfit2(:,k))];     
        parsfit(k).bg_corr=[xGrid(:,k),yGrid(:,k)]
        parsfit(k).peak1=gaussfit1(:,k);
        parsfit(k).peak2=gaussfit2(:,k);

        varargout{k} = parsfit(k)    
    
    elseif size(par_start,2) ==3 %one gaussian
        parsfit(k).Volt = pars_fit(k,1);     
        parsfit(k).FWHM = pars_fit(k,2);     
        parsfit(k).area = pars_fit(k,3);     
        parsfit(k).Imax = max(gaussfit(:,k));
        parsfit(k).bg_corr=[xGrid(:,k),yGrid(:,k)];
        parsfit(k).peak=gaussfit(:,k);

        varargout{k} = parsfit(k)    
    end
    
    
end
end