#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	level thread on_player_connect();
}

IsSliding() //You can use this function like BO3/BO4/BOCW's IsSliding() function to check if the player is sliding.
{
	if(is_true(self.isSliding))
		return true;
	return false;
}

on_player_connect()
{
	level endon("end_game");
	while(1)
	{
		level waittill("connected", player);
		player thread waitToSlide();
	}
}

waitToSlide()
{
	self.isSliding = false;
	self.isReadyToSlide = true;
	while(1)
	{
		if(self IsSprinting() && self IsOnGround())
		{
			while(self IsSprinting())
			{
				wait .01;
			}
			if(!self IsOnGround())
			{
				while(!self IsOnGround())
				{
					wait .01;
				}
			}
			self checkCrouch();
		}
		wait .01;
	}
}

checkCrouch()
{
	if(self GetStance() == "crouch" && !self.Sliding && self.isReadyToSlide)
	{
		self.is_sliding = true;
		self.isReadyToSlide = false;
		self.is_drinking = true;
		self SetStance( "crouch" );
		self AllowProne(false);
		self AllowAds(false);
		self AllowMelee(false);
		self startSliding(300,1);
		self.is_drinking = false;
		self.isSliding = false;
		self AllowAds(true);
		self AllowMelee(true);
		self AllowProne(true);
		self.isReadyToSlide = true;
	}
}

startSliding(force,time)
{
	angles = (0,(self GetPlayerAngles()[1]),0);
	forward = AnglesToForward(angles);
	time = time*0.18;
	distance = 20;
	for(i=0;i<time && self IsOnGround() && distance > 5; i+=0.01)
	{
		if(self GetStance() == "stand")
		{
			self thread doAJump();
			return;
		}
		position = self.origin;
		wait 0.01;
		self SetVelocity(forward * force);
		distance = Distance(position, self.origin);
	}
}

doAJump()
{
	if(self IsSprinting())
		return;
	self SetOrigin(self.origin + (0,0,5));
	self SetVelocity( self GetVelocity() + (0,0,250) );
	wait .1;
	while(!self IsOnGround())
	{
		wait .01;
	}
	self checkCrouch();
}
