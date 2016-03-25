Shader "Custom/chroma" {
		Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
		_AlphaTexture ("_AlphaTexture", 2D) = "white" {}
		_Ligegyldig ("_Ligegyldig", float) = 0

	}

	SubShader
	{

		Tags
		{
			"Queue" = "Transparent"
		}

		 Cull Front // first pass renders only back faces
             // (the "inside")
         ZWrite Off // don't write to depth buffer
            // in order not to occlude other objects
         Blend SrcAlpha OneMinusSrcAlpha // use alpha blending


		Pass
		{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				struct appdata_t
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					fixed4 color : COLOR;
				};

				struct v2f
				{
					float4 vertex : SV_POSITION;
					half2 texcoord : TEXCOORD0;
					fixed4 color : COLOR;
				};

				float _Ligegyldig;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _AlphaTexture;

				v2f vert (appdata_t v)
				{
					v2f o;
					o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.color = v.color;
				#ifdef UNITY_HALF_TEXEL_OFFSET
					o.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
				#endif
					return o;
				}

				float4 frag (v2f i) : COLOR
				{


					float4 col = tex2D(_MainTex, i.texcoord) ;//* i.color;
					float myMax = max(max(col.x, col.y),col.z);
					float myMin = min(min(col.x, col.y),col.z);
					float H;

					if (myMin == myMax)
					{
						return float4(col.x, col.y, col.z, 1.0);
					}

					if (col.x > col.y && col.x > col.z)
					{
						H = (((col.y - col.z)/(myMax - myMin))%6) * 60;
					}

					if (col.y > col.x)
					{
						if (col.y > col.z)
						{
						H = (((col.z - col.x)/(myMax - myMin)) + 2) * 60;
						}
					}

					if (col.z > col.x && col.z > col.y)
					{
						H = (((col.x - col.y)/(myMax - myMin)) + 4) * 60;
					}

					float4 tmpColor = tex2D(_AlphaTexture, float2((H / 360), 0));

					float saturation = (myMax - myMin)/ myMax;
					float4 mySaturation = tex2D(_AlphaTexture, float2(saturation,0));
					float4 myValue = tex2D(_AlphaTexture, float2(myMax,0));

				if(_Ligegyldig == 1){
					return float4(1-tmpColor.y, 1-tmpColor.y, 1-tmpColor.y,1);
				}else if(_Ligegyldig == 2){
					return float4(col.x, col.y, col.z, 1);
				}else if(_Ligegyldig == 3){
					return float4(mySaturation.z, mySaturation.z, mySaturation.z,1);
				}else{
					return float4(col.x, col.y, col.z, (1-tmpColor.y) * (1-mySaturation.z));// * (myValue.x));
				}
					//return float4(tmpColor.y,tmpColor.y,tmpColor.y,1);


					//return float4(_Ligegyldig, 0,_Ligegyldig, _Ligegyldig);



				}
			ENDCG
		}
	}
}
