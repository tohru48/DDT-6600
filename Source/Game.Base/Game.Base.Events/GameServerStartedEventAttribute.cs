namespace Game.Base.Events
{
    using System;

    [AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
    public class GameServerStartedEventAttribute : Attribute
    {
        public GameServerStartedEventAttribute()
        {
        }
    }
}
