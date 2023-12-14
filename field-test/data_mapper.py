import xml.etree.ElementTree as et
import geopy.distance
import subprocess
import datetime 


seconds_in_day = 24 * 60 * 60
seconds_in_month = seconds_in_day * 30
seconds_in_year = seconds_in_month * 12
receiver_cords = (49.87234949343273, 8.635738820722167)

tree = et.parse('funktest2/fieldtest.gpx')
root = tree.getroot()
ele = [-1] * len(root[1][1])
times = []
for i in range(0,len(root[1][1])):
    times.append(datetime.datetime.strptime(root[1][1][i][1].text[:-5], '%Y-%m-%dT%H:%M:%S')) 

filename = "funktest2/reson7_icom/2023-12-07_15.16.15.wav"
rattle_time_correction = datetime.timedelta(0, 60 * 60)
filetime = filename.split("/")[-1]
rattle_time = datetime.datetime.strptime(filetime[:-4], '%Y-%m-%d_%H.%M.%S')
rattle_time = rattle_time - rattle_time_correction
rattle_delta = 20


def get_time_delta_seconds_abs(time1, time2):
    delta = time1 - time2
    delta_seconds = delta.days*seconds_in_day + delta.seconds
    return delta_seconds

def find_closest_time_index(time, maximum_delta):
    max_delta = maximum_delta
    index = -1
    for i in range(0,len(times)):
        current = times[i]
        delta_seconds = abs(get_time_delta_seconds_abs(current, time))
        if (delta_seconds < max_delta):
             max_delta = delta_seconds
             index = i
    return index 

def get_rattlegram_data(filename, message_delta):
    result = subprocess.run(["./decode " + filename + " 0 8 | grep Bit"], shell=True, capture_output=True, text=True)
    out = result.stdout.split('\n')
    rattle_res = []
    for elem in out:
        temp = elem.split(' ')
        if len(temp) == 5 and int(temp[4]) != -1:
            rattle_res.append([int(temp[1]), 1])
    print(str(len(rattle_res)) + " packets received.")
    rattle_data = []        
    for current, succ in zip(rattle_res, rattle_res[1:]):
        rattle_data.append(current)
        gap = int((succ[0]-current[0])/message_delta)
        if gap > 1:
            interval = succ[0]-current[0]
            for i in range(1,gap):
                rattle_data.append([current[0]+i*int(interval/gap), 0])
    if len(rattle_data) > 0: 
        rattle_data.append(rattle_res[-1])
    return rattle_data  

def get_ax25_data(filename, message_delta):
    result = subprocess.run(["atest " + filename + "| grep DECODED"], shell=True, capture_output=True, text=True)
    out = result.stdout.split('\n')
    res = []
    for elem in out:
        temp = elem.split(' ')
        if len(temp) == 12:
            temp = temp[1]
            temp = temp.split('.')[0]
            temp = temp.split(':')
            sec = 60*int(temp[0])+int(temp[1])
            res.append([sec, 1])
    print(str(len(res)) + " packets received.")
    res_data = []
    for current, succ in zip(res, res[1:]):
        res_data.append(current)
        gap = int((succ[0]-current[0])/message_delta)
        if gap > 1:
            interval = succ[0]-current[0]
            for i in range(1,gap):
                res_data.append([current[0]+i*int(interval/gap), 0])
    if len(res_data) > 0:            
        res_data.append(res[-1])
        res_data.append([res_data[-1][0] + message_delta, 0])
    return res_data  

def get_distance_to_receiver(index):
    node = root[1][1][i].attrib
    coordinate = (float(node['lat']), float(node['lon']))
    return geopy.distance.geodesic(coordinate, receiver_cords).m

rattle_data = get_rattlegram_data(filename, rattle_delta)
#rattle_data = get_ax25_data(filename, rattle_delta)

for i in range(0, len(rattle_data)):
    rattle_current_time = rattle_time + datetime.timedelta(0, rattle_data[i][0])
    index = find_closest_time_index(rattle_current_time, rattle_delta)
    if index != -1:
        ele[index] = rattle_data[i][1]
#for i in range(0, len(ele)):
    #if ele[i] != -1:
        #print(times[i])
        #print(ele[i])
max_distance = -1 
for i in range (0, len(ele)):
    if ele[i] == 1:
        distance = get_distance_to_receiver(i)
        if distance > max_distance:
            max_distance = distance
print("Maximum distance (m): "+ str(max_distance))

prev = -1
for i in range(0, len(ele)):
    if ele[i] != -1:
        if prev != -1 and (i-prev) > 1:
            interval = get_time_delta_seconds_abs(times[i], times[prev])
            diff = (ele[i] - ele[prev])
            for j in range(prev+1, i):
                sub_interval = get_time_delta_seconds_abs(times[j], times[prev])
                ele[j] = ele[prev]+sub_interval/interval*diff
        prev = i

for i in range(0,len(ele)):
    if ele[i] == -1:
        ele[i] = 0
    root[1][1][i][0].text = str(round(ele[i], 5))   
      
#tree.write('output.gpx')
