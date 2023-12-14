from gpxplotter import read_gpx_file, create_folium_map, add_segment_to_map
import folium
from branca.colormap import LinearColormap

color_map = LinearColormap(['#ff0000', '#00ff00'])
the_map = create_folium_map()
folium.LayerControl(sortLayers=True).add_to(the_map)
for track in read_gpx_file('output.gpx'):
    for i, segment in enumerate(track['segments']):
        #print(segment)
        add_segment_to_map(the_map, segment, color_by='elevation', cmap=color_map)
folium.Marker(
    location=[49.87234949343273, 8.635738820722167],
    icon=folium.Icon(icon='signal', color='green')
    ).add_to(the_map)
# To display the map in a Jupyter notebook:
the_map.save('map.html')