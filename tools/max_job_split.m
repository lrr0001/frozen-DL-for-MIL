function [minID,maxID] = multi_job_split(kk)
    max_number_of_jobs = 1000;
    ii = 1;
    while(true)
        minID(ii) = (ii - 1)*max_number_of_jobs + 1;
        maxID(ii) = min(kk,ii*max_number_of_jobs);
        if kk<ii*max_number_of_jobs
            break;
        end
        ii = ii + 1;
    end
end
