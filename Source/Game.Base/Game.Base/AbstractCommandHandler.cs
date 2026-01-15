namespace Game.Base
{
    using System;

    public abstract class AbstractCommandHandler
    {
        protected AbstractCommandHandler()
        {
        }

        public virtual void DisplayMessage(BaseClient client, string message)
        {
            if (client != null)
            {
                client.DisplayMessage(message);
            }
        }

        public virtual void DisplayMessage(BaseClient client, string format, params object[] args)
        {
            this.DisplayMessage(client, string.Format(format, args));
        }

        public virtual void DisplaySyntax(BaseClient client)
        {
            if (client != null)
            {
                CmdAttribute[] customAttributes = (CmdAttribute[])base.GetType().GetCustomAttributes(typeof(CmdAttribute), false);
                if (customAttributes.Length > 0)
                {
                    client.DisplayMessage(customAttributes[0].Description);
                    foreach (string str in customAttributes[0].Usage)
                    {
                        client.DisplayMessage(str);
                    }
                }
            }
        }
    }
}
