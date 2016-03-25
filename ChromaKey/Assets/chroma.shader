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


					float4 col = tex2D(_MainTex, i.texcoord) * i.color;
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

					if (col.z > col.y)
					{
						if (col.z > col.x)
						{
						H = (((col.y - col.x)/(myMax - myMin)) + 2) * 60;
						}
					}

					if (col.y > col.x && col.y > col.z)
					{
						H = (((col.x - col.y)/(myMax - myMin)) + 4) * 60;
					}

					float4 tmpColor = tex2D(_AlphaTexture, float2(H / 360, 0));

					if (H > 100)
						{
						if (H < 200)
						{
							return float4(col.x, col.y, col.z, 0.0);
						}
					}
					return float4(col.x, col.y, col.z, tmpColor.y);

					//return float4(_Ligegyldig, 0,_Ligegyldig, _Ligegyldig);



				}
			ENDCG
		}
	}
}
