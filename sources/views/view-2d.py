# Import modules
import re
import glob
import sys
import optparse
from paraview.simple import *

# Parse command line options
parser = optparse.OptionParser()
parser.add_option('-v', '--video', dest = 'file_video')
parser.add_option('-i', '--input', dest = 'field_name')
parser.add_option('-r', '--range', dest = 'range')
parser.add_option('-p', '--plots', dest = 'dirplots')
(options, args) = parser.parse_args()

# Ask for file name if undefined
if options.field_name is None:
    options.field_name = raw_input('Enter field name:')

# Paraview code
paraview.simple._DisableFirstRenderCameraReset()

# Read data file
files = sorted(glob.glob("output/"+options.field_name+".*.vtk"), key=lambda x: int(x.split('.')[1]))
scalarField = LegacyVTKReader(FileNames=files)

# Retrieve name of scalar field
cellData = str(scalarField.GetCellDataInformation().GetFieldData())
list_data_names = re.findall(r'Name: (.+)', cellData)
list_data_names.remove('Label')
data_name = list_data_names[0];

# Animation
animationScene = GetAnimationScene()
animationScene.UpdateAnimationUsingDataTimeSteps()

# Get active view and display scalar field in it
renderView = GetActiveViewOrCreate('RenderView')
display = Show(scalarField, renderView)

# Set field to color
ColorBy(display, ('CELLS', data_name))

# show color bar/color legend
display.SetScalarBarVisibility(renderView, True)

# Set range
if options.range is None:
    display.RescaleTransferFunctionToDataRange(True)
else:
    bounds = options.range.split(',')
    scalarLUT = GetColorTransferFunction(data_name)
    scalarLUT.RescaleTransferFunction(float(bounds[0]), float(bounds[1]))

# reset view to fit data
renderView.ResetCamera()

# Set representation type
# display.SetRepresentationType('Surface With Edges')
display.SetRepresentationType('Surface')

# Save video or play animation
if options.file_video is not None:
    WriteAnimation(options.file_video, Magnification=1, FrameRate=40.0, Compression=True)
elif options.dirplots is not None:
    index = 0;
    while True:
        animationScene.GoToNext()
        SaveScreenshot(options.dirplots+"/"+options.field_name+"."+str(index)+".png", magnification=1, quality=100, view=renderView)
        index = index + 1
else:
    animationScene.Play()
