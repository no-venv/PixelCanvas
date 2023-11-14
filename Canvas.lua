local Canvas = {}
Canvas.__index = Canvas

local init = {}

type Canvas = {
	Pixels : {number},
	EasyPixels : {{number}},
	Image : EditableImage
}

local function index(x,y,width)
	return (width * (y - 1) + x) 
end

local TopCorner = Vector2.new(0,0)

function Canvas:Draw()
	
	local self : Canvas = self
	
	local index = 1

	for i=1,(self.Image.Size.X*self.Image.Size.Y*4),4 do
		
		self.Pixels[i] = self.EasyPixels[index][1]
		self.Pixels[i+1] = self.EasyPixels[index][2]
		self.Pixels[i+2] = self.EasyPixels[index][3]
		
		index +=1
	end
	
	self.Image:WritePixels(TopCorner,self.Image.Size,self.Pixels)
	
end

function Canvas:SetPixel(x,y,r,g,b)
	
	local self : Canvas = self
	
	local cursor = index(x,y,self.Image.Size.X)

	self.EasyPixels[cursor][1] = r
	self.EasyPixels[cursor][2] = g
	self.EasyPixels[cursor][3] = b

end

function init:New(Width : number, Height : number, Parent : Instance )
	
	local ScreenGui = Instance.new("ScreenGui")
	local ImageLabel = Instance.new("ImageLabel")
	local DynImage  : EditableImage  = Instance.new("EditableImage")
	
	DynImage.Parent = ImageLabel
	ImageLabel.Parent = ScreenGui
	ScreenGui.Parent = Parent

	DynImage.Size = Vector2.new(Width,Height)
	ImageLabel.Size = UDim2.new(0,Width,0,Height)
	ScreenGui.IgnoreGuiInset = true
	
	local self = {}
	
	# Array of RGBA Pixels ( width * height * 4 )
	self.Pixels = table.create((Width*Height*4),1)
	
	self.EasyPixels = (function()
		local _ = {}
		
		for i=1,Width*Height do
			_[i] = {1,0,0}
		end
		
		return _
	end)()
	
	self.Image = DynImage
	
	return setmetatable(self,Canvas)
end

return init
