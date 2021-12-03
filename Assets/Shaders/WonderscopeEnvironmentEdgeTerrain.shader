// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Wonderscope/EnvironmentEdgeTerrain"
{
	Properties
	{
		_BaseColor1("Base Color 1", 2D) = "white" {}
		_TintBC1("Tint BC1", Color) = (1,1,1,0)
		_BaseColor2R("Base Color 2 (R)", 2D) = "white" {}
		_TintBC2("Tint BC2", Color) = (1,1,1,0)
		_Mask("Mask", 2D) = "white" {}
		_BumpMap("Normal", 2D) = "bump" {}
		_MetallicGlossMap("Metallic", 2D) = "black" {}
		_BlendStrength("Blend Strength", Range( 1 , 20)) = 1
		_MaskInfluence("Mask Influence", Range( 0 , 15)) = 1
		_PushPull("Push/Pull", Range( 0 , 1)) = 0
		_BlendSharpen("Blend Sharpen", Range( 1 , 10)) = 1
		_BC1GradientColor("BC1 Gradient Color", Color) = (0.5,0.5,0.5,0)
		_BC1GradientMaskInfluence("BC1 Gradient Mask Influence", Range( 0 , 1)) = 0
		_BC1GradientLength("BC1 Gradient Length", Range( 1 , 3)) = 1
		_BC1GradientStrength("BC1 Gradient Strength", Range( 0 , 20)) = 1
		_BC2EdgeColor("BC2 Edge Color", Color) = (0,0,0,0)
		_BC2EdgeStrength("BC2 Edge Strength", Float) = 1
		_BC2GradientColour("BC2 Gradient Colour", Color) = (0.5,0.5,0.5,0)
		_BC2GradientMaskInfluence("BC2 Gradient Mask Influence", Range( 0 , 1)) = 0
		_BC2GrandientLength("BC2 Grandient Length", Range( 1 , 2)) = 1
		[Toggle]_UseAutumnTex("UseAutumnTex", Range( 0 , 1)) = 0
		_AutumnTex("AutumnTex", 2D) = "white" {}
		_AutumnColorBlend("AutumnColorBlend", Range( 0 , 1)) = 0
		[Toggle]_SimpleAutumnColor("Simple Autumn Color", Range( 0 , 1)) = 0
		_AutumnColor1("AutumnColor", Color) = (0.8396226,0.5022165,0.1069331,1)
		_WinterColorBlend("WinterColorBlend", Range( 0 , 1)) = 0
		_WinterColor1("WinterColor", Color) = (0.3848789,0.6008307,0.8773585,1)
		_SnowIntensityMultiplier("SnowIntensityMultiplier", Range( 0 , 5)) = 1.5
		_SnowNormalPower("SnowNormalPower", Range( 0 , 20)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _BaseColor1;
		uniform float4 _BaseColor1_ST;
		uniform float4 _TintBC1;
		uniform float4 _BC1GradientColor;
		uniform float _BC1GradientLength;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _MaskInfluence;
		uniform float _BC1GradientMaskInfluence;
		uniform float _BC1GradientStrength;
		uniform sampler2D _BaseColor2R;
		uniform float4 _BaseColor2R_ST;
		uniform float4 _TintBC2;
		uniform float4 _BC2GradientColour;
		uniform float _BC2GrandientLength;
		uniform float _BC2GradientMaskInfluence;
		uniform float4 _BC2EdgeColor;
		uniform float _BC2EdgeStrength;
		uniform float _BlendStrength;
		uniform float _PushPull;
		uniform float _BlendSharpen;
		uniform float4 _WinterColor1;
		uniform float _WinterColorBlend;
		uniform float _GlobalSnowAmount;
		uniform float _UseAutumnTex;
		uniform sampler2D _AutumnTex;
		uniform float4 _AutumnTex_ST;
		uniform float4 _AutumnColor1;
		uniform float _SimpleAutumnColor;
		uniform float _AutumnColorBlend;
		uniform float _GlobalAutumnBlend;
		uniform sampler2D _GlobalSnowTexture;
		uniform float4 _GlobalSnowTextureTiling;
		uniform float _SnowNormalPower;
		uniform float _SnowIntensityMultiplier;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform float _GlobalSnowSmoothness1;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult19 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 temp_output_120_0 = ( tex2D( _BaseColor1, ( ( _BaseColor1_ST.xy * appendResult19 ) + _BaseColor1_ST.zw ) ) * _TintBC1 );
			float4 blendOpSrc126 = temp_output_120_0;
			float4 blendOpDest126 = _BC1GradientColor;
			float VertColorRed130 = i.vertexColor.r;
			float2 appendResult73 = (float2(ase_worldPos.x , ase_worldPos.z));
			float lerpResult87 = lerp( 0.0 , ( tex2D( _Mask, ( ( _Mask_ST.xy * appendResult73 ) + _Mask_ST.zw ) ).r * _MaskInfluence ) , VertColorRed130);
			float clampResult85 = clamp( ( lerpResult87 + VertColorRed130 ) , 0.0 , 1.0 );
			float WithModulation132 = clampResult85;
			float lerpResult147 = lerp( VertColorRed130 , WithModulation132 , _BC1GradientMaskInfluence);
			float clampResult125 = clamp( pow( ( _BC1GradientLength * ( 1.0 - lerpResult147 ) ) , _BC1GradientStrength ) , 0.0 , 1.0 );
			float4 lerpResult121 = lerp( ( saturate( (( blendOpDest126 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest126 ) * ( 1.0 - blendOpSrc126 ) ) : ( 2.0 * blendOpDest126 * blendOpSrc126 ) ) )) , temp_output_120_0 , clampResult125);
			float2 appendResult59 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 temp_output_55_0 = ( tex2D( _BaseColor2R, ( ( _BaseColor2R_ST.xy * appendResult59 ) + _BaseColor2R_ST.zw ) ) * _TintBC2 );
			float4 blendOpSrc98 = temp_output_55_0;
			float4 blendOpDest98 = _BC2GradientColour;
			float clampResult105 = clamp( ( _BC2GrandientLength * VertColorRed130 ) , 0.0 , 1.0 );
			float lerpResult99 = lerp( clampResult105 , WithModulation132 , _BC2GradientMaskInfluence);
			float4 lerpResult52 = lerp( ( saturate( (( blendOpDest98 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest98 ) * ( 1.0 - blendOpSrc98 ) ) : ( 2.0 * blendOpDest98 * blendOpSrc98 ) ) )) , temp_output_55_0 , lerpResult99);
			float clampResult67 = clamp( ( ( WithModulation132 * _BlendStrength ) - ( _BlendStrength * _PushPull ) ) , 0.0 , 1.0 );
			float FinalBlendPosition142 = clampResult67;
			float clampResult107 = clamp( ( _BC2EdgeStrength * ( 1.0 - FinalBlendPosition142 ) ) , 0.0 , 1.0 );
			float4 lerpResult51 = lerp( lerpResult52 , _BC2EdgeColor , clampResult107);
			float clampResult118 = clamp( ( _BlendSharpen * clampResult67 ) , 0.0 , 1.0 );
			float4 lerpResult64 = lerp( lerpResult121 , lerpResult51 , clampResult118);
			float4 temp_output_1_0_g1 = lerpResult64;
			float4 lerpResult14_g1 = lerp( temp_output_1_0_g1 , ( temp_output_1_0_g1 * _WinterColor1 ) , ( _WinterColorBlend * _GlobalSnowAmount ));
			float2 uv_AutumnTex = i.uv_texcoord * _AutumnTex_ST.xy + _AutumnTex_ST.zw;
			float4 tex2DNode15_g1 = tex2D( _AutumnTex, uv_AutumnTex );
			float4 lerpResult22_g1 = lerp( ( _AutumnColor1 * lerpResult14_g1 ) , _AutumnColor1 , _SimpleAutumnColor);
			float4 ifLocalVar18_g1 = 0;
			if( _UseAutumnTex >= 1.0 )
				ifLocalVar18_g1 = tex2DNode15_g1;
			else
				ifLocalVar18_g1 = lerpResult22_g1;
			float4 lerpResult20_g1 = lerp( lerpResult14_g1 , ifLocalVar18_g1 , ( _AutumnColorBlend * _GlobalAutumnBlend ));
			float2 appendResult17_g2 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult24_g2 = (float2(_GlobalSnowTextureTiling.x , _GlobalSnowTextureTiling.y));
			float4 tex2DNode3_g2 = tex2D( _GlobalSnowTexture, ( appendResult17_g2 * appendResult24_g2 ) );
			float4 snowAlbedo155 = tex2DNode3_g2;
			float snowTexAlpha6_g2 = tex2DNode3_g2.a;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult4_g2 = dot( ase_normWorldNormal , float3(0,1,0) );
			float temp_output_8_0_g2 = pow( saturate( dotResult4_g2 ) , _SnowNormalPower );
			float temp_output_26_0_g2 = _SnowIntensityMultiplier;
			float lerpResult12_g2 = lerp( ( snowTexAlpha6_g2 * temp_output_8_0_g2 * temp_output_26_0_g2 ) , 1.0 , temp_output_8_0_g2);
			float snowAmount156 = saturate( ( lerpResult12_g2 * temp_output_26_0_g2 * _GlobalSnowAmount ) );
			float4 lerpResult152 = lerp( lerpResult20_g1 , snowAlbedo155 , snowAmount156);
			float4 albedo149 = lerpResult152;
			o.Albedo = albedo149.rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode35 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			float lerpResult161 = lerp( tex2DNode35.r , 0.0 , snowAmount156);
			o.Metallic = lerpResult161;
			float lerpResult162 = lerp( tex2DNode35.a , _GlobalSnowSmoothness1 , snowAmount156);
			o.Smoothness = lerpResult162;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
410;105;1777;816;1494.144;37.29808;3.114161;True;True
Node;AmplifyShaderEditor.CommentaryNode;84;-3240.722,-876.4055;Inherit;False;1344.815;592.0284;Mask;8;77;79;72;74;73;75;76;38;Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;72;-3190.722,-826.4055;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureTransformNode;74;-3019.058,-659.6906;Inherit;False;38;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.DynamicAppendNode;73;-2943.359,-786.8275;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;81;-2240.29,179.7239;Inherit;False;905.3692;344.47;Vert Color Gradient;5;63;65;68;134;130;Vert Color Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2771.411,-809.6714;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;63;-2191.021,230.7239;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-2557.651,-729.9223;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2348.535,-404.3771;Inherit;False;Property;_MaskInfluence;Mask Influence;8;0;Create;True;0;0;0;False;0;False;1;4.1;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-2124.141,-169.2867;Inherit;False;1030.114;211.3086;Mask Texture within 0-1 Vert Color Range, then add to modulate;7;85;83;87;86;135;132;136;Modulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-1991.166,249.048;Inherit;False;VertColorRed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-2369.439,-759.4985;Inherit;True;Property;_Mask;Mask;4;0;Create;True;0;0;0;True;0;False;-1;None;d68db407ff511b24583c01e275198798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;135;-2080.012,-38.23791;Inherit;False;130;VertColorRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2074.141,-119.2866;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2057.897,-501.8443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;87;-1858.567,-113.3326;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;136;-1695.803,-13.23796;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-1635.341,-113.6367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;-1468.028,-112.978;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-1686.945,625.8732;Inherit;False;752.4597;196.5712;Push/Pull;3;88;91;90;Push/Pull;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-1287.803,-118.238;Inherit;False;WithModulation;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-1702.34,322.7385;Inherit;False;132;WithModulation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1642.945,696.8732;Inherit;False;Property;_PushPull;Push/Pull;9;0;Create;True;0;0;0;False;0;False;0;0.47;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;82;-2200.192,1431.489;Inherit;False;1745.366;1251.779;Tiling and Colors;16;28;61;60;58;59;57;120;1;119;18;55;56;27;19;62;17;Tiling and Base Color, Base Tints;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1769.29,423.194;Inherit;False;Property;_BlendStrength;Blend Strength;7;0;Create;True;0;0;0;False;0;False;1;5;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1496.921,328.1944;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-2059.621,2136.86;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1308.944,683.8732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;141;-254.9517,745.8174;Inherit;False;1057.874;461.0972;BC1 Gradient Modulation;9;139;125;144;145;124;140;123;146;147;BC1 Gradient Modulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;115;-850.5404,538.0314;Inherit;False;475.4;318.5193;Final Blend Position;2;142;67;Final Blend Position;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-1112.885,688.9444;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;58;-1887.958,2303.576;Inherit;False;62;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-2058.025,1547.923;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;59;-1812.26,2176.438;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-1640.312,2153.594;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1810.662,1587.501;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;67;-796.9684,588.0318;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;27;-1886.361,1714.638;Inherit;False;1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;148;-238.4117,1121.395;Inherit;False;Property;_BC1GradientMaskInfluence;BC1 Gradient Mask Influence;12;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-228.9517,919.3403;Inherit;False;130;VertColorRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;137;-355.4772,2392.83;Inherit;False;899.3368;435.6655;BC2 Gradient Modulation;7;104;131;103;105;99;133;100;BC2 Gradient Modulation;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;-231.4363,1002.217;Inherit;False;132;WithModulation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-305.4773,2442.83;Inherit;False;Property;_BC2GrandientLength;BC2 Grandient Length;19;0;Create;True;0;0;0;False;0;False;1;1;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-1414.558,2232.343;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1638.713,1564.657;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-622.1051,694.5002;Inherit;False;FinalBlendPosition;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;35.42334,983.5198;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-255.672,2537.883;Inherit;False;130;VertColorRed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;56;-906.3555,2387.118;Inherit;False;Property;_TintBC2;Tint BC2;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.1408,0.3264,0.4,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;-64.45517,788.8174;Inherit;False;Property;_BC1GradientLength;BC1 Gradient Length;13;0;Create;True;0;0;0;False;0;False;1;1.25;1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;143;642.4423,2020.447;Inherit;False;142;FinalBlendPosition;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;114;590.056,1828.131;Inherit;False;949.1294;621.6545;Comment;6;96;51;107;36;106;108;BC2 Edge;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1414.96,1644.406;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;8.666547,2482.088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-269.7589,1925.726;Inherit;False;739.2705;387.1772;Comment;3;98;52;49;BC2 Gradient Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;62;-995.2335,2204.968;Inherit;True;Property;_BaseColor2R;Base Color 2 (R);2;0;Create;True;0;0;0;True;0;False;-1;None;1ba7a789d73bf1345963e69d24bc3992;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;140;191.5461,983.6299;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;27.85973,2712.496;Inherit;False;Property;_BC2GradientMaskInfluence;BC2 Gradient Mask Influence;18;0;Create;True;0;0;0;False;0;False;0;0.686;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;219.8867,788.9374;Inherit;False;Property;_BC1GradientStrength;BC1 Gradient Strength;14;0;Create;True;0;0;0;False;0;False;1;1.8;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;96;866.6909,2025.028;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-630.1116,2186.751;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;127;545.322,411.8612;Inherit;False;668.3127;310.2438;Blend Sharpening;3;116;117;118;Blend Sharpening;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;138;289.0202,1387.158;Inherit;False;770.2181;378.1892;Comment;3;126;121;122;BC1 Gradient Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;105;163.3588,2483.215;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;853.056,1893.131;Inherit;False;Property;_BC2EdgeStrength;BC2 Edge Strength;16;0;Create;True;0;0;0;False;0;False;1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;-916.2884,1805.649;Inherit;False;Property;_TintBC1;Tint BC1;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;376.748,894.4011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-997.4127,1621.252;Inherit;True;Property;_BaseColor1;Base Color 1;0;0;Create;True;0;0;0;True;0;False;-1;None;184e96e763f21c242bb4e6298aa323b8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;49;-219.7589,1975.726;Inherit;False;Property;_BC2GradientColour;BC2 Gradient Colour;17;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0.7520281,0.809,0.6152958,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;133;-248.8459,2632.573;Inherit;False;132;WithModulation;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;144;547.8867,806.9374;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;99;361.8596,2576.495;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;160;1791.404,2117.101;Inherit;False;972.4805;258.6313;Comment;4;154;155;156;159;Snow;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;122;339.0203,1437.158;Inherit;False;Property;_BC1GradientColor;BC1 Gradient Color;11;0;Create;True;0;0;0;False;0;False;0.5,0.5,0.5,0;0.5459999,0.5142945,0.368004,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-647.2884,1628.649;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;98;31.94336,2092.344;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;1027.496,2001.837;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;595.322,461.8613;Inherit;False;Property;_BlendSharpen;Blend Sharpen;10;0;Create;True;0;0;0;False;0;False;1;2;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;107;1179.033,2001.725;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;1841.404,2186.758;Inherit;False;Property;_SnowIntensityMultiplier;SnowIntensityMultiplier;28;0;Create;False;0;0;0;False;0;False;1.5;1.5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;1011.697,2230.786;Inherit;False;Property;_BC2EdgeColor;BC2 Edge Color;15;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.106,0.009636355,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;125;660.9219,1081.915;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;126;607.4492,1547.431;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;52;287.5116,2153.903;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;849.4669,562.2609;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;1357.185,2146.221;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;121;854.2392,1613.347;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;112;1567.911,1568.984;Inherit;False;232;209;Final Blend Lerp;1;64;Final Blend Lerp;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;118;1042.635,563.105;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;154;2161.948,2194.272;Inherit;False;GetSnow;29;;2;a6b677fe4d0605d46bde1ae86a5ea4db;0;1;26;FLOAT;1.5;False;2;COLOR;22;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;1617.911,1618.984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;2539.885,2259.732;Inherit;False;snowAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;155;2536.179,2167.101;Inherit;False;snowAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;153;1897.554,1618.296;Inherit;False;SeasonTint;20;;1;1603c31f343d47646b1d6a531b8aebe8;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;2030.944,1699.811;Inherit;False;155;snowAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;158;2042.059,1793.677;Inherit;False;156;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;2260.128,1621.898;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;1651.662,745.2968;Inherit;True;Property;_MetallicGlossMap;Metallic;6;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;2514.711,1615.407;Inherit;False;albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;164;1822.502,1113.12;Inherit;False;Global;_GlobalSnowSmoothness1;_GlobalSnowSmoothness;6;0;Create;True;0;0;0;False;0;False;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;165;1908.301,1211.92;Inherit;False;156;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;163;1977.202,853.1202;Inherit;False;156;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;2255.595,549.8217;Inherit;False;149;albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;162;2157.902,1068.92;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;161;2180.001,771.22;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;1785.034,517.3547;Inherit;True;Property;_BumpMap;Normal;5;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2477.985,689.4852;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Wonderscope/EnvironmentEdgeTerrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;0;72;1
WireConnection;73;1;72;3
WireConnection;75;0;74;0
WireConnection;75;1;73;0
WireConnection;76;0;75;0
WireConnection;76;1;74;1
WireConnection;130;0;63;1
WireConnection;38;1;76;0
WireConnection;77;0;38;1
WireConnection;77;1;79;0
WireConnection;87;0;86;0
WireConnection;87;1;77;0
WireConnection;87;2;135;0
WireConnection;136;0;135;0
WireConnection;83;0;87;0
WireConnection;83;1;136;0
WireConnection;85;0;83;0
WireConnection;132;0;85;0
WireConnection;65;0;134;0
WireConnection;65;1;68;0
WireConnection;91;0;68;0
WireConnection;91;1;90;0
WireConnection;88;0;65;0
WireConnection;88;1;91;0
WireConnection;59;0;57;1
WireConnection;59;1;57;3
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;19;0;17;1
WireConnection;19;1;17;3
WireConnection;67;0;88;0
WireConnection;61;0;60;0
WireConnection;61;1;58;1
WireConnection;18;0;27;0
WireConnection;18;1;19;0
WireConnection;142;0;67;0
WireConnection;147;0;139;0
WireConnection;147;1;146;0
WireConnection;147;2;148;0
WireConnection;28;0;18;0
WireConnection;28;1;27;1
WireConnection;103;0;104;0
WireConnection;103;1;131;0
WireConnection;62;1;61;0
WireConnection;140;0;147;0
WireConnection;96;0;143;0
WireConnection;55;0;62;0
WireConnection;55;1;56;0
WireConnection;105;0;103;0
WireConnection;124;0;123;0
WireConnection;124;1;140;0
WireConnection;1;1;28;0
WireConnection;144;0;124;0
WireConnection;144;1;145;0
WireConnection;99;0;105;0
WireConnection;99;1;133;0
WireConnection;99;2;100;0
WireConnection;120;0;1;0
WireConnection;120;1;119;0
WireConnection;98;0;55;0
WireConnection;98;1;49;0
WireConnection;106;0;108;0
WireConnection;106;1;96;0
WireConnection;107;0;106;0
WireConnection;125;0;144;0
WireConnection;126;0;120;0
WireConnection;126;1;122;0
WireConnection;52;0;98;0
WireConnection;52;1;55;0
WireConnection;52;2;99;0
WireConnection;117;0;116;0
WireConnection;117;1;67;0
WireConnection;51;0;52;0
WireConnection;51;1;36;0
WireConnection;51;2;107;0
WireConnection;121;0;126;0
WireConnection;121;1;120;0
WireConnection;121;2;125;0
WireConnection;118;0;117;0
WireConnection;154;26;159;0
WireConnection;64;0;121;0
WireConnection;64;1;51;0
WireConnection;64;2;118;0
WireConnection;156;0;154;0
WireConnection;155;0;154;22
WireConnection;153;1;64;0
WireConnection;152;0;153;0
WireConnection;152;1;157;0
WireConnection;152;2;158;0
WireConnection;149;0;152;0
WireConnection;162;0;35;4
WireConnection;162;1;164;0
WireConnection;162;2;165;0
WireConnection;161;0;35;1
WireConnection;161;2;163;0
WireConnection;0;0;150;0
WireConnection;0;1;20;0
WireConnection;0;3;161;0
WireConnection;0;4;162;0
ASEEND*/
//CHKSM=5F59315F33908C2F0D45B9BFD927CFF3BC92F5E7