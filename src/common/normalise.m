function normalised = normalise( map )
map = map - min(min(map));
s = max(max(map));
if s > 0
    normalised = map / s;
else
    normalised = map;
end

