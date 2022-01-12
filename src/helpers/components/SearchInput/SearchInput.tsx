import { Flex, Input, InputProps, MagnifyingGlassIcon, SpacingUnitV2, SpacingUnitV3, useSpace } from "palette"
import React from "react"
import { useWindowDimensions, View } from "react-native"

export interface SearchInputProps extends InputProps {
  enableCancelButton?: boolean
  onCancelPress?: () => void
}

export const SearchInput: React.FC<SearchInputProps> = ({
  enableCancelButton,
  onChangeText,
  onClear,
  onCancelPress,
  ...props
}) => {
  const space = useSpace()
  const width = useWindowDimensions().width - space(4)

  return (
    <Flex flexDirection="row">
      <View
        style={{
          width: width,
        }}
      >
        <Input
          icon={<MagnifyingGlassIcon width={18} height={18} />}
          autoCorrect={false}
          enableClearButton
          returnKeyType="search"
          onClear={() => {
            onClear?.()
          }}
          onChangeText={onChangeText}
          {...props}
          onFocus={(e) => {
            props.onFocus?.(e)
          }}
          onBlur={(e) => {
            props.onBlur?.(e)
          }}
        />
      </View>
    </Flex>
  )
}
