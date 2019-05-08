function [minID,maxID] = multi_job_split(kk)
    ii = 1;
    while(true)
        minID(ii) = (ii - 1)*2000 + 1;
        maxID(ii) = min(kk,ii*2000);
        if kk<ii*2000
            break;
        end
    end
end
