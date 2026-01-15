// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.KhurungSimpleFriendNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Drawing;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class KhurungSimpleFriendNpc : ABrain
  {
    private int m_attackTurn = 0;
    private int isSay = 0;
    private Point[] brithPoint = new Point[5]
    {
      new Point(979, 630),
      new Point(1013, 630),
      new Point(1052, 630),
      new Point(1088, 630),
      new Point(1142, 630)
    };
    private static string[] AddBooldChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] ShootedChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] KillPlayerChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };
    private static string[] DiedChat = new string[7]
    {
      "Vai Mi Matar ? HAHAHAHA...",
      "Você é um Bostinha....",
      "Vou Acabar com você",
      "Curta Nos no Facebook",
      "Chame Seus Amigos tbm Nubs.. HAHAHAH",
      "Melhor DDTank é Aqui...",
      "Que Pena de Você... UHAUHAHUHUA"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.isSay = 0;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 1169 && allFightPlayer.X < this.Game.Map.Info.ForegroundWidth + 1)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (this.m_attackTurn == 0)
      {
        this.BuffHeath();
        ++this.m_attackTurn;
      }
      else
      {
        this.BuffHeath();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void BuffHeath()
    {
      int index = this.Game.Random.Next(0, KhurungSimpleFriendNpc.AddBooldChat.Length);
      this.Body.Say(KhurungSimpleFriendNpc.AddBooldChat[index], 1, 0);
      this.Body.SyncAtTime = true;
      this.Body.PlayMovie("renew", 1000, 4500);
      foreach (Living allLivingPlayer in this.Game.GetAllLivingPlayers())
        allLivingPlayer.AddBlood(5000);
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, KhurungSimpleFriendNpc.KillPlayerChat.Length);
      this.Body.Say(KhurungSimpleFriendNpc.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnDiedSay()
    {
      int index = this.Game.Random.Next(0, KhurungSimpleFriendNpc.DiedChat.Length);
      this.Body.Say(KhurungSimpleFriendNpc.DiedChat[index], 1, 0, 1500);
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, KhurungSimpleFriendNpc.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(KhurungSimpleFriendNpc.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, KhurungSimpleFriendNpc.DiedChat.Length);
      this.Body.Say(KhurungSimpleFriendNpc.DiedChat[index2], 1, 100, 2000);
    }
  }
}
