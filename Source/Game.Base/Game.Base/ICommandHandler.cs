namespace Game.Base
{
    using System;

    public interface ICommandHandler
    {
        bool OnCommand(BaseClient client, string[] args);
    }
}
