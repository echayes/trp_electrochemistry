function [gaussfit,y_bg_new,forpar,revpar,difpar]=Volt_splinegauss_simple(ex,ey,bounds);

%generate the polynomial background
[y_bg,y_corr,xGrid,yGrid]=Volt_spline(ex,ey,bounds);

nTraces = size(ey,2);
nBounds = size(bounds,2);
% Compute step size ------------------------------------------------
step=(ex(end,1)-ex(end-1,1));

% find indices of the boundaries
for k=1:nTraces
    for j=1:nBounds
    bound_idx(k,j) = find(abs(ex(:,k)-bounds(k,j)) < step,1);
    end
end

% add gaussians in for the peaks
for k = 1:nTraces
    %smooth for finding starting gaussian parameters
    ys_corr(:,k) = datasmooth(y_corr(:,k),80);
    
    if size(bounds,2)==4% for two sets of boundaries (two gaussians expected)
        [Imax1(k,:),IIdx1(k,:)] = max(ys_corr(bound_idx(k,1):bound_idx(k,2),k));%,'threshold',max(ys_corr(:,k)*0.1));
        [Imax2(k,:),IIdx2(k,:)] = max(ys_corr(bound_idx(k,3):bound_idx(k,4),k));%,'threshold',max(ys_corr(:,k)*0.1));
        Imax(k,:)=[Imax1(k,:) Imax2(k,:)];
        IIdx(k,:)=[IIdx1(k,:) IIdx2(k,:)];

        Vstart(k,:) = ex(IIdx(k,:),k);        

    elseif size(bounds,2)==2% for one set of boundaries (one gaussian expected)
        [Imax(k,:),IIdx(k,:)] = max(ys_corr(:,k));
        Vstart(k,:) = ex(IIdx(k,:),k);
    end
end

% starting fwhm for a gaussian fit from deriv max and min
if     size(Vstart,2)==2 % for 2 gaussians
        FWHMstart(1,:) = [0.1 0.1];
        FWHMstart(2,:) = [0.1 0.1];
        FWHMstart(3,:) = [0.1 0.1];
elseif size(Vstart,2)==1 % for 1 gaussian
        FWHMstart(1,:) = 0.1;
        FWHMstart(2,:) = 0.1;
        FWHMstart(3,:) = 0.1;
end

%find intensity based on fwhm and intensity
int = FWHMstart.*Imax;

% set starting params for gaussian fit(s)
par_start(1,:) = [Vstart(1,:) FWHMstart(1,:) int(1,:)];% a(1,:)];
par_start(2,:) = [Vstart(2,:) FWHMstart(2,:) int(2,:)];% a(2,:)];
par_start(3,:) = [Vstart(3,:) FWHMstart(3,:) int(3,:)];% a(3,:)];

[gaussfit,y_bg_new,forpar,revpar,difpar] = voltgauss(par_start,ex,ey,y_bg);
forpar.bg_corr=[xGrid(:,1),yGrid(:,1)]
revpar.bg_corr=[xGrid(:,2),yGrid(:,2)]
difpar.bg_corr=[xGrid(:,3),yGrid(:,3)]

end