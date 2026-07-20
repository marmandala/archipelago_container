import xml.etree.ElementTree as ET
from xml.dom import minidom
import random
import os

TEMPLATE_PATH = "/home/developer/PX4-Autopilot/Tools/simulation/gz/worlds/default.sdf"
OUTPUT_PATH = "/home/developer/workspace/worlds/forest.sdf"
SYMLINK_PATH = "/home/developer/PX4-Autopilot/Tools/simulation/gz/worlds/forest.sdf"
NUM_TREES = 30
RADIUS = 0.3
HEIGHT = 5.0

def create_tree_element(index, x, y):
    model = ET.Element("model", name=f"tree_{index}")
    pose = ET.SubElement(model, "pose")
    pose.text = f"{x} {y} {HEIGHT/2} 0 0 0"
    static = ET.SubElement(model, "static")
    static.text = "true"
    
    link = ET.SubElement(model, "link", name="link")
    
    collision = ET.SubElement(link, "collision", name="collision")
    c_geom = ET.SubElement(collision, "geometry")
    c_cyl = ET.SubElement(c_geom, "cylinder")
    ET.SubElement(c_cyl, "radius").text = str(RADIUS)
    ET.SubElement(c_cyl, "length").text = str(HEIGHT)
    
    visual = ET.SubElement(link, "visual", name="visual")
    v_geom = ET.SubElement(visual, "geometry")
    v_cyl = ET.SubElement(v_geom, "cylinder")
    ET.SubElement(v_cyl, "radius").text = str(RADIUS)
    ET.SubElement(v_cyl, "length").text = str(HEIGHT)
    
    material = ET.SubElement(visual, "material")
    ambient = ET.SubElement(material, "ambient")
    ambient.text = "0.3 0.2 0.1 1"
    diffuse = ET.SubElement(material, "diffuse")
    diffuse.text = "0.4 0.25 0.1 1"
    
    return model

def main():
    os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)
    
    tree = ET.parse(TEMPLATE_PATH)
    root = tree.getroot()
    world = root.find("world")
    
    # Меняем внутреннее имя мира
    if world is not None:
        world.set("name", "forest")
    
    for i in range(NUM_TREES):
        x = random.uniform(3.0, 18.0)
        y = random.uniform(-7.5, 7.5)
        tree_model = create_tree_element(i, x, y)
        world.append(tree_model)
    
    # Красивое форматирование XML (с переносами строк)
    xmlstr = minidom.parseString(ET.tostring(root)).toprettyxml(indent="  ")
    # minidom добавляет лишнюю <?xml?>, уберем ее, так как она может конфликтовать со стандартом SDF
    xmlstr = '\n'.join([line for line in xmlstr.split('\n') if line.strip() and not line.startswith('<?xml')])
    
    with open(OUTPUT_PATH, "w") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write(xmlstr)
        
    print(f"Successfully generated {NUM_TREES} trees in {OUTPUT_PATH}")
    
    # Создаем симлинк в папку PX4
    try:
        if os.path.lexists(SYMLINK_PATH):
            os.remove(SYMLINK_PATH)
        os.symlink(OUTPUT_PATH, SYMLINK_PATH)
        print(f"Symlink created at {SYMLINK_PATH}")
    except Exception as e:
        print(f"Warning: failed to create symlink: {e}")

if __name__ == "__main__":
    main()
