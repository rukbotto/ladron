package utils;

import com.haxepunk.Entity;

class Tools {

    public static function checkOverlap(entity:Entity, entities:Array<Entity>,
            types:Array<String>):Bool
    {
        for (entity2 in filterEntities(types,entities)) 
        {
            if (entity.mask.collide(entity2.mask))
            {
                return false;
            }
        }
        return true;
    }

    public static function filterEntities(types:Array<String>, 
            entities:Array<Entity>):Array<Entity> 
    {
        var result: Array<Entity> = [];
        for (entity in entities)
        {
            if (contains(entity.type, types))
            {
                result.push(entity);
            }
        }
        return result;
    }

    public static function contains(value:String, array:Array<String>): Bool
    {
        for (val in array)
        {
            if (value == val)
            {
                return true;
            }
        }
        return false;
    }   

}
