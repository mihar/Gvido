rule = lambda{|n| n%100==1 ? :one : n%100==2 ? :few : n%100==3 || n%100==4 ? :many : :other}
{:sl => {:i18n => {:plural => {:keys => [:one, :few, :other], :rule => rule}}}}