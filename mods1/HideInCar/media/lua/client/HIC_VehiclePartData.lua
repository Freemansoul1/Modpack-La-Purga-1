function HIC.VehiclePartData(id, required)
    return
    {
        id = id or "";
        required = required or false;

        isRequired = function (self)return self.required; end,
        getId = function (self) return self.id; end
    }
end