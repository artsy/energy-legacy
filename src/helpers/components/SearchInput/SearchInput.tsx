import { Flex, Input, InputProps, MagnifyingGlassIcon } from "palette"
import React from "react"

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

  return (
    <Flex flexDirection="row" justifyContent="center">
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
    </Flex>
  )
}
