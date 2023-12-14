function s = random_string(len)
    symbols = ['a':'z' 'A':'Z' '0':'9'];
    nums = randi(numel(symbols),[1 len]);
    s = symbols (nums);
end 