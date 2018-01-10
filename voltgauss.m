function [gaussfit,y_bg,parsfitfor,parsfitrev,parsfitdif]=voltgauss(par_start,ex,ey,y_bg)
nTraces=size(par_start,1);
%par_start(q,1) or par_start(q,[1 2])= x0 center of gaussian
%par_start(q,2) or par_start(q,[3 4])= FWHM
%par_start(q,3) or par_start(q,[5 6])= intensity


pars_fit = fminsearch(@polygausserror1,par_start,optimset('TolX',1e-4));

    function ErrErr = polygausserror1(par_start)
        
        % create gaussians based on starting parameters
        % create new boundaries for baseline based on gaussian starting
        % parameters
        for r=1:nTraces
            if size(par_start,2)==6
            gaussfit1(:,r) = gaussian(ex(:,r),par_start(r,1),par_start(r,3))*par_start(r,5);
            gaussfit2(:,r) = gaussian(ex(:,r),par_start(r,2),par_start(r,4))*par_start(r,6);
            totalfit(:,r)  = gaussfit1(:,r) + gaussfit2(:,r) + y_bg(:,r);
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

if size(par_start,2)==6
    parsfitfor.Volt = pars_fit(1,[1 2]) ; parsfitrev.Volt = pars_fit(2,[1 2]) ; parsfitdif.Volt = pars_fit(3,[1 2]) ;
    parsfitfor.FWHM = pars_fit(1,[3 4]) ; parsfitrev.FWHM = pars_fit(2,[3 4]) ; parsfitdif.FWHM = pars_fit(3,[3 4]) ;
    parsfitfor.area = pars_fit(1,[5 6]) ; parsfitrev.area = pars_fit(2,[5 6]) ; parsfitdif.area = pars_fit(3,[5 6]) ;
    
    %parsfitfor.Imax = pars_fit(1,[7 8]) ; parsfitrev.Imax = pars_fit(2,[7 8]) ; parsfitdif.Imax = pars_fit(3,[7 8])

elseif size(par_start,2)==3
    parsfitfor.Volt = pars_fit(1,1)     ; parsfitrev.Volt = pars_fit(2,1)     ; parsfitdif.Volt = pars_fit(3,1) ;
    parsfitfor.FWHM = pars_fit(1,2)     ; parsfitrev.FWHM = pars_fit(2,2)     ; parsfitdif.FWHM = pars_fit(3,2) ;
    parsfitfor.area = pars_fit(1,3)     ; parsfitrev.area = pars_fit(2,3)     ; parsfitdif.area = pars_fit(3,3) ;
    parsfitfor.Imax = max(gaussfit(:,1)); parsfitrev.Imax = max(gaussfit(:,2)); parsfitdif.Imax = max(gaussfit(:,3));

end
end

            